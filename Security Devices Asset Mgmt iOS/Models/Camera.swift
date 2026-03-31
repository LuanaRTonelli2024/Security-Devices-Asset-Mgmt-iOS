//
//  Camera.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/30/26.
//

import Foundation

struct CameraDTO: Codable {
    let id: String?
    let name: String?
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
