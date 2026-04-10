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
    @State private var errorMessage: String?
    @State private var showEditSheet = false
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)

            Form {
                Section("Profile") {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        Text(authManager.currentUser?.email ?? "-")
                            .font(.system(size: 15, design: .serif))
                    }
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        Text(authManager.currentUser?.displayName ?? "-")
                            .font(.system(size: 15, design: .serif))
                    }
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(authManager.currentUser?.isActive == true ? .green : .secondary)
                            .frame(width: 20)
                            .font(.system(size: 8))
                        Text(authManager.currentUser?.isActive == true ? "Active" : "Inactive")
                            .font(.system(size: 15, design: .serif))
                    }
                }

                Section {
                    Button(action: { showEditSheet = true }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit profile")
                                .font(.system(size: 15, design: .serif))
                        }
                        .foregroundColor(Color(red: 0.1, green: 0.37, blue: 0.71))
                    }
                }


                Section {
                    Button(role: .destructive) {
                        let result = authManager.logout()
                        if case .failure(let failure) = result {
                            self.errorMessage = failure.localizedDescription
                        } else {
                            self.errorMessage = nil
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign out")
                                .font(.system(size: 15, design: .serif))
                        }
                    }
                }
            }
            .onAppear {
                authManager.fetchCurrentAppUser { _ in }
            }
        }
        .padding(.top, 30)
        .sheet(isPresented: $showEditSheet) {
            EditProfileSheet()
                .environmentObject(authManager)
        }
        
    }
}

//#Preview {
//    ProfileView()
//}
