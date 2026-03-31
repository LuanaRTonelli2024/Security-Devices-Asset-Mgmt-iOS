//
//  Company.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/30/26.
//

import Foundation

struct CompanyDTO: Codable {
    let id: String?
    let name: String?
    let address: String?
    let contact: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
        case contact
    }
}

