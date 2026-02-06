//
//  AuthManager.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/18/25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    
    //singleton pattern
    static let shared = AuthManager()
    
    @Published var user: User? // User -> FirebaseAuth.User
    
    private let db = Firestore.firestore()
    
    @Published var currentUser: AppUser?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // register
    // email, password
    func register(email: String, password: String, displayName: String, completion: @escaping (Result<User, Error>) -> Void){
        //@escaping makes yhis func async
        // Result --> user or error
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if let error = error {
                completion(.failure(error))
            }
            //guard statement for user
            guard let user = result?.user else {
                return completion(.failure(SimpleError("Unable to create the user"))) //Custom error
            }
            //Uid from the FirebaseAuth.user
            let uid = user.uid
            let appUser = AppUser(id: uid, email: email, displayName: displayName)
            //AppUser to Firestore
            do {
                try self.db.collection("users").document(uid).setData(from: appUser) {
                    error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(error))
                        
                    }
                    DispatchQueue.main.async {
                        self.currentUser = appUser //will update currentuser in the main thread
                        completion(.success(user))
                    }
                    completion(.success(user))
                }
            }
            catch {
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    //login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password:password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let user = result?.user {
                self.user = user
                completion(.success(user))
            }
        }
    }
    
    //logout/signout
//    func logout(){
//        do {
//            try Auth.auth().signOut()
//            self.user = nil
//        }
//        catch {
//            print("Error Signing out: \(error.localizedDescription)")
//        }
//    }
    
    func logout() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.currentUser = nil
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    
    
    //fetch current user (firestore)
    func fetchCurrentAppUser(completion: @escaping (Result<AppUser?, Error>)-> Void){
        guard let uid = Auth.auth().currentUser?.uid
        else {
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return completion(.success(nil))
        }
        db.collection("users").document(uid).getDocument {snap, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let snap = snap else {
                return completion(.success(nil))
            }
            do {
                //destructure the stream of data to AppUser
                let user = try snap.data(as: AppUser.self)
                DispatchQueue.main.async {
                    self.currentUser = user
                }
                completion(.success(user))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    //update profile details
    func updateProfile(displayName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        //uid
        guard let uid = Auth.auth().currentUser?.uid
        else {
            return completion(.failure(SimpleError("Unable to fetch User details")))
        }
        db.collection("users").document(uid).updateData(["displayName":displayName]) { error in
            if let error = error {
                return completion(.failure(error))
            }
            else {
                //re-fetch the currentUser
                self.fetchCurrentAppUser {_ in
                    completion(.success(()))
                }
            }
        }
    }
}
