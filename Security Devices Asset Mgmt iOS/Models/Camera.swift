//
//  Camera.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/14/25.
//

import Foundation

struct Camera: Identifiable, Codable {
    let id: String
    let name: String
    let location: String?
    let ipAddress: String?
    let subnetMask: String?
    let defaultGateway: String?
    let userName: String?
    let password: String?
    let companyId: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case location
        case ipAddress
        case subnetMask
        case defaultGateway
        case userName
        case password
        case companyId
    }
}


struct CameraListResponse: Codable {
    let cameras: [Camera]
}


struct DeleteCameraResponse: Codable {
    let cameraId: String
}

struct CameraResponse: Codable {
    let cameras: [Camera]
}

