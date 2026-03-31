//
//  CameraUpdateRequest.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/30/26.
//

import Foundation

struct CameraUpdateRequest: Codable {
    let name: String
    let location: String?
    let ipAddress: String?
    let subnetMask: String?
    let defaultGateway: String?
    let userName: String?
    let password: String?
    let imageUrl: String?

    init(from e: CameraEntity) {
        name = e.name ?? ""
        location = e.location
        ipAddress = e.ipAddress
        subnetMask = e.subnetMask
        defaultGateway = e.defaultGateway
        userName = e.userName
        password = e.password
        imageUrl = e.imageUrl
        // companyId excluded — API does not allow updating companyId
    }
}

