//
//  AuthGate.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/18/25.
//

import SwiftUI

struct AuthGate: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        
        if authManager.user != nil {
            HomeView()
        }
        else {
            ContentView()
        }
    }
}
