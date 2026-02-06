//
//  FirebaseCompanyViewModel.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import Foundation
import Combine //Obserable Pattern
import FirebaseFirestore


class FirebaseCompanyViewModel: ObservableObject {
    
    //static reference
    static let shared = FirebaseCompanyViewModel()
     
    private let db = Firestore.firestore() //the database reference
    
    @Published var companies: [Company] = [] //empty list
   
    init(){
        fetchCompanies()
    }
   
    func fetchCompanies() {
        //callback method
        db.collection("companies").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
             
            //to convert the stream of data to the Camera Model
            self.companies = querySnapshot?.documents.compactMap({ document in
                try? document.data(as: Company.self)
            }) ?? []
        }
    }
     
    //add a Company
    func addCompany(name: String){
        let newCompany = Company(name: name)
        do{
            try db.collection("companies").addDocument(from: newCompany)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
