//
//  FirebaseCameraView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import Foundation
import Combine //Obserable Pattern
import FirebaseFirestore

class FirebaseCameraViewModel: ObservableObject {
    
    //static reference
    static let shared = FirebaseCameraViewModel()
     
    private let db = Firestore.firestore() //the database reference
    
    @Published var cameras: [Camera] = [] //empty list
   
    init(){
        //fetchCamerasCompany(for company: Company)
    }
   
    func fetchCameras() {
        //callback method
        db.collection("cameras").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
             
            //to convert the stream of data to the Camera Model
            self.cameras = querySnapshot?.documents.compactMap({ document in
                try? document.data(as: Camera.self)
            }) ?? []
        }
    }
    
    func getCameraById(_ id: String) -> Camera? {
        return cameras.first(where: { $0.id == id })
    }

    func fetchCamerasCompany(for company: Company) {
        guard let companyId = company.id else { return }
        
        //callback method
        db.collection("cameras")
            .whereField("companyId", isEqualTo: companyId).addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                //to convert the stream of data to the Camera Model
                self.cameras = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Camera.self)
                } ?? []
            }
        }
                                                                    
    //add a Camera
    func addCamera(name: String,
                   location: String,
                   ipAddress: String,
                   subnetMask: String,
                   defaultGateway: String,
                   userName: String,
                   password: String,
                   for company: Company){
        guard let companyId = company.id else { return }
        let newCamera = Camera(
                name: name,
                location: location,
                ipAddress: ipAddress,
                subnetMask: subnetMask,
                defaultGateway: defaultGateway,
                userName: userName,
                password: password,
                companyId: companyId)
        do{
            try db.collection("cameras").addDocument(from: newCamera)
        }
        catch {
            print(error.localizedDescription)
        }
    }
     

    //uptade info camera ---> ID of the camera, access the camera, update infos
    func updateCamera(camera: Camera){
        guard let cameraId = camera.id else { return }
       
        db.collection("cameras").document(cameraId).updateData([
            "name": camera.name,
            "location": camera.location,
            "ipAddress": camera.ipAddress,
            "subnetMask": camera.subnetMask,
            "defaultGateway": camera.defaultGateway,
            "userName": camera.userName,
            "password": camera.password,
            "companyId": camera.companyId
        ])
    }

     

    //delete the camera ---> ID of the camera, access the camera, delete the camera
    func deleteCamera(camera: Camera) {
        guard let cameraId = camera.id else { return }
        
        //callback
        db.collection("cameras").document(cameraId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
