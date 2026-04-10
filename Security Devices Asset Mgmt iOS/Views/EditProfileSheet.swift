//
//  EditProfileSheet.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-04-09.
//

import SwiftUI

struct EditProfileSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager

    @State private var newName = ""
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Display name") {
                    HStack(spacing: 10) {
                        Image(systemName: "person")
                            .foregroundColor(.secondary)
                            .frame(width: 18)
                        TextField("New display name", text: $newName)
                            .font(.system(size: 15, design: .serif))
                    }
                }

                Section("Password") {
                    HStack(spacing: 10) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.secondary)
                            .frame(width: 18)
                        SecureField("Current password", text: $currentPassword)
                            .font(.system(size: 15, design: .serif))
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "lock")
                            .foregroundColor(.secondary)
                            .frame(width: 18)
                        SecureField("New password", text: $newPassword)
                            .font(.system(size: 15, design: .serif))
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "lock.rotation")
                            .foregroundColor(.secondary)
                            .frame(width: 18)
                        SecureField("Confirm new password", text: $confirmPassword)
                            .font(.system(size: 15, design: .serif))
                    }
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 12, design: .serif))
                        .foregroundStyle(.red)
                }

                Section {
                    Button("Save changes") {
                        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty || !newPassword.isEmpty else {
                            self.errorMessage = "Fill in at least one field"
                            return
                        }

                        
                        if !newName.trimmingCharacters(in: .whitespaces).isEmpty {
                            authManager.updateProfile(displayName: newName) { result in
                                switch result {
                                case .success:
                                    self.errorMessage = nil
                                case .failure(let failure):
                                    self.errorMessage = failure.localizedDescription
                                }
                            }
                        }

                     
                        if !newPassword.isEmpty {
                            guard newPassword == confirmPassword else {
                                self.errorMessage = "Passwords don't match"
                                return
                            }
                            guard Validators.isValidPassword(newPassword) else {
                                self.errorMessage = "Invalid password"
                                return
                            }
                            guard !currentPassword.isEmpty else {
                                self.errorMessage = "Enter your current password"
                                return
                            }
                            authManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { result in
                                switch result {
                                case .success:
                                    self.errorMessage = nil
                                    dismiss()
                                case .failure(let failure):
                                    self.errorMessage = failure.localizedDescription
                                }
                            }
                        } else {
                            dismiss()
                        }
                    }
                    .font(.system(size: 15, design: .serif))
                    .foregroundColor(Color(red: 0.1, green: 0.37, blue: 0.71))
                }
            }
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 15, design: .serif))
                }
            }
        }
    }
}
