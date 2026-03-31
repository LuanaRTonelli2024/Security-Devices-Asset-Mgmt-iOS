//
//  Company.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/27/26.
//

import Foundation

struct Company: Identifiable, Codable {
    var id: String?
    var name: String
    var address: String?
    var contact: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
        case contact
    }
}

struct CompanyResponse: Codable {
    let companies: [Company]
}

struct DeleteCompanyResponse: Codable {
    let companyId: String
}
