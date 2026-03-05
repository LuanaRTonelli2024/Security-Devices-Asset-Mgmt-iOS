//
//  APICompany.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/27/26.
//

import Foundation

struct APICompany: Identifiable, Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct CompanyResponse: Codable {
    let companies: [APICompany]
}
