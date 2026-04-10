//
//  ContentView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Luana Rocca Tonelli on 2026-02-05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    //Login states
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack(alignment: .top) {

                    // --- Imagen full bleed ignorando safe area ---
                    GeometryReader { geo in
                        Image("cctv")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height * 0.52)
                            .clipped()
                            .overlay(
                                // Difuminado hacia abajo
                                LinearGradient(
                                    stops: [
                                        .init(color: .clear, location: 0.0),
                                        .init(color: .clear, location: 0.55),
                                        .init(color: Color(.systemBackground), location: 1.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .ignoresSafeArea(edges: .top)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.52)
                    .ignoresSafeArea(edges: .top)

                    // --- Contenido ---
                    VStack(spacing: 0) {

                        // Espacio para que el texto quede sobre el fade
                        Spacer().frame(height: UIScreen.main.bounds.height * 0.33)

                        VStack(spacing: 2) {
                            Text("Security Devices")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                            Text("Asset Management")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                            Text("All the information you need is here")
                                .font(.custom("AvenirNext-Regular", size: 14))
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, 24)

                        // --- Campos de login ---
                        VStack(spacing: 12) {

                            Text("Login")
                                .font(.custom("AvenirNext-DemiBold", size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 28)

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
                            Button(action: { login() }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            email.isEmpty || password.isEmpty
                                                ? Color.gray.opacity(0.3)
                                                : Color(red: 0.1, green: 0.37, blue: 0.71)
                                        )
                                        .frame(height: 46)
                                    if isLoading {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Sign in")
                                            .font(.custom("AvenirNext-DemiBold", size: 16))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .disabled(email.isEmpty || password.isEmpty || isLoading)
                            .animation(.easeInOut, value: isLoading)
                            .padding(.top, 4)

                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.custom("AvenirNext-Regular", size: 12))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(.secondary)
                                NavigationLink(destination: RegisterView().environmentObject(authManager)) {
                                    Text("Register here")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 0.1, green: 0.37, blue: 0.71))
                                }
                            }
                            .font(.custom("AvenirNext-Regular", size: 13))
                            .padding(.top, 2)
                        }
                        .padding(.horizontal, 24)

                        Spacer()
                    }
                }
                .navigationBarHidden(true)
            }
    
    
    private func login() {
        guard Validators.isEmailValid(email) else {
            errorMessage = "Invalid Email"
            return
        }
        guard Validators.isValidPassword(password) else {
            errorMessage = "Invalid Password"
            return
        }
        
        isLoading = true
        
        authManager.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
            }
            
            switch result {
            case .success:
                errorMessage = nil
            case .failure(let failure):
                errorMessage = failure.localizedDescription
            }
        }
    }
}
