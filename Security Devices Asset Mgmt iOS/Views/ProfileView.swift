//
//  ProfileView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/23/25.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    //@ObservedObject private var auth = AuthManager.shared
    
    @State private var newName = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.headline)
                .background(Color(.systemBackground))
            
            
            Form {
                Section("Profile") {
                    Text("Email: \(authManager.currentUser?.email ?? "-")")
                    Text("Display Name: \(authManager.currentUser?.displayName ?? "-")")
                    Text("Is Active: \(authManager.currentUser?.isActive == true ? "Yes" : "False")")
                }
                
                Section("Update Display Name") {
                    TextField("New Display Name", text: $newName)
                    Button("Save") {
                        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty
                        else {
                            self.errorMessage = "display name cannot be empty"
                            return
                        }
                        
                        authManager.updateProfile(displayName: newName) { result in
                            switch result {
                            case .success:
                                self.errorMessage = nil
                            case .failure(let failure):
                                self.errorMessage = failure.localizedDescription
                            }
                        }
                    }
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundStyle(.red)
                }
                
                Button(role: .destructive) {
                    let result = authManager.logout()
                    if case .failure(let failure) = result {
                        self.errorMessage = failure.localizedDescription
                    } else {
                        self.errorMessage = nil
                    }
                } label: {
                    Text("Sign Out")
                }
            }
            .onAppear {
                authManager.fetchCurrentAppUser { _ in
                    //leave it empty
                    //for re-fetching purposes
                    //when logged in it will profile page, we need fetch here.
                }
            }
        }
        .padding(.top, 30)
    }
}

//#Preview {
//    ProfileView()
//}
