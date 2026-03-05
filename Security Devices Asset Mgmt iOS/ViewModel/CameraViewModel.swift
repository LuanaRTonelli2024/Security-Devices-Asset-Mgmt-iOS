//
//  CameraViewModel.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/27/26.
//

import Foundation
import Combine


class CameraViewModel: ObservableObject {
    
    @Published var cameraData = [Camera]()
    
    @MainActor
    func fetchCamerasByCompany(token: String, companyId: String) async {
        
        guard let response: CameraListResponse = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/cameras/company/\(companyId)",
            method: .GET)
        else{
            return
        }
        
        cameraData = response.cameras
    }
    
    //create
    func createCamera(token: String,
                      name: String,
                      location: String,
                      ipAddress: String,
                      subnetMask: String,
                      defaultGateway: String,
                      userName: String,
                      password: String,
                      for company: Company) async {
        
        let body = Camera(id: nil,
                          name: name,
                          location: location,
                          ipAddress: ipAddress,
                          subnetMask: subnetMask,
                          defaultGateway: defaultGateway,
                          userName: userName,
                          password: password,
                          companyId: company.id)
        
        if let result: Camera = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/cameras/",
            method: .POST,
            body: body
        ) {
            print("created: \(result.id ?? "no id")")
            
            await fetchCamerasByCompany(token: token, companyId: company.id ?? "")
        }
    }
    
    //delete
    func deleteCamera(id: String?, token: String) async {
        
        guard let id = id else {
            print("Error: Camera ID is nil.")
            return
        }
        
        if let result: DeleteCameraResponse = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/camera/\(id)",
            method: .DELETE
        ) {
            print("Deleted camera: \(result.cameraId)")
        }
        
        await MainActor.run{
            cameraData.removeAll{ $0.id == id}
        }
    }
    
    
    
    //update
    func updateCamera(token: String,
                      id: String,
                      newName: String,
                      newLocation: String,
                      newIpAddress: String,
                      newSubnetMask: String,
                      newDefaultGateway: String,
                      newUserName: String,
                      newPassword: String,
                      for company: Company) async {
        
        let body = Camera(id: nil,
                          name: newName,
                          location: newLocation,
                          ipAddress: newIpAddress,
                          subnetMask: newSubnetMask,
                          defaultGateway: newDefaultGateway,
                          userName: newUserName,
                          password: newPassword,
                          companyId: company.id)
        
        if let result: Camera = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/cameras/\(id)",
            method: .PATCH,
            body: body
        ) {
            print("Updated camera: \(result.id ?? "no id")")
        }
        
        await fetchCamerasByCompany(token: token, companyId: company.id ?? "")
    }
    
    
    func fetchCameraById(token: String, cameraId: String) async {
        
        guard let response: Camera = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/cameras/\(cameraId)",
            method: .GET)
        else{
            return
        }
        
        //cameraData = response.cameras
    }
    
    
    func getCameraById(_ id: String) -> Camera? {
        return cameraData.first { $0.id == id }
    }
}
    

