//
//  AppUser.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import Foundation
import FirebaseFirestore

struct AppUser: Identifiable, Codable {
    
    @DocumentID var id: String? //FirebaseAuth.currentUser.uid
    let email: String //canot be changed after
    var displayName: String
    var isActive: Bool = true
}
