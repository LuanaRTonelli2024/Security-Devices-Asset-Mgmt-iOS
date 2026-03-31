//
//  CameraCreateRequest.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/30/26.
//

import Foundation

struct CameraCreateRequest: Codable {
    let name: String
    let location: String
    let ipAddress: String
    let subnetMask: String
    let defaultGateway: String
    let userName: String
    let password: String
    let companyId: String?
    
    init(from e: CameraEntity) {
        name           = e.name ?? ""
        location       = e.location ?? ""
        ipAddress      = e.ipAddress ?? ""
        subnetMask     = e.subnetMask ?? ""
        defaultGateway = e.defaultGateway ?? ""
        userName       = e.userName ?? ""
        password       = e.password ?? ""
        companyId      = e.companyId
    }
}
