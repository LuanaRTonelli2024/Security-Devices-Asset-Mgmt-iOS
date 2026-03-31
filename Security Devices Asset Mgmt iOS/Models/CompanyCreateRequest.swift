//
//  CompanyCreateRequest.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/30/26.
//

import Foundation

struct CompanyCreateRequest: Codable {
    let name: String
    let address: String?
    let contact: String?
    init(from e: CompanyEntity) {
        name    = e.name    ?? ""
        address = e.address
        contact = e.contact
    }
}

