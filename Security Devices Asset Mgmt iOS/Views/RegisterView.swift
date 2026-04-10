//
//  RegisterView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import SwiftUI

struct RegisterView: View {

    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String?
    @State private var registrationSuccess = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Create account")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            VStack(spacing: 3) {
                Text("Register")
                    .font(.custom("AvenirNext-DemiBold", size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 28)
                Text("Fill in the fields below")
                    .font(.custom("AvenirNext-Regular", size: 14))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 8)
            .padding(.bottom, 8)

            // Display name
            HStack(spacing: 10) {
                Image(systemName: "person")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(width: 18)
                TextField("Display name", text: $displayName)
                    .font(.custom("AvenirNext-Regular", size: 15))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Color(.systemGray6).opacity(0.7))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )

            // Email
            HStack(spacing: 10) {
                Image(systemName: "envelope")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(width: 18)
                TextField("Email", text: $email)
                    .font(.custom("AvenirNext-Regular", size: 15))
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Color(.systemGray6).opacity(0.7))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )

            // Password
            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(width: 18)
                SecureField("Password", text: $password)
                    .font(.custom("AvenirNext-Regular", size: 15))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Color(.systemGray6).opacity(0.7))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )

            // Botón
            Button(action: { handleRegister() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            email.isEmpty || password.isEmpty || displayName.isEmpty
                                ? Color.gray.opacity(0.3)
                                : Color(red: 0.1, green: 0.37, blue: 0.71)
                        )
                        .frame(height: 46)
                    Text("Create account")
                        .font(.custom("AvenirNext-DemiBold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .disabled(email.isEmpty || password.isEmpty || displayName.isEmpty)
            .padding(.top, 4)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.custom("AvenirNext-Regular", size: 12))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if registrationSuccess {
                Text("✅ User created successfully.")
                    .font(.custom("AvenirNext-Regular", size: 14))
                    .foregroundColor(.green)
                    .onAppear { dismiss() }
            }

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
        
    }

    private func handleRegister() {
        guard Validators.isEmailValid(email) else { errorMessage = "Invalid Email"; return }
        guard Validators.isValidPassword(password) else { errorMessage = "Invalid Password"; return }
        guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Display name is required"; return
        }
        authManager.register(email: email, password: password, displayName: displayName) { result in
            switch result {
            case .success: errorMessage = nil; registrationSuccess = true
            case .failure(let failure): errorMessage = failure.localizedDescription
            }
        }
    }
}
