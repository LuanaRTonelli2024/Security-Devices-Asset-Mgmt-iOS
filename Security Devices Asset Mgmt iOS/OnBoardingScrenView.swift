//
//  OnBoardingScrenView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/18/25.
//

import SwiftUI

struct OnBoardingScrenView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    //Login states
    @State private var email = ""
    @State private var password = ""
    //@EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String?
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 30){
                
                Image("cctv")
                    .resizable()
                    .scaledToFill()
                    .padding()
                
                VStack(spacing: 6){
                    Text("Security Devices")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("Asset Management")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    Text("All the information you need is here!")
                        .font(.title3)
                        .foregroundStyle(.black.opacity(0.7))
                }
                
                
                //                NavigationLink(destination: LoginView().environmentObject(authManager)) {
                //                    RoundedRectangle(cornerRadius: 12)
                //                        .fill(.blue)
                //                        .frame(width: 280, height: 60, alignment: .trailing)
                //                        .overlay {
                //                            HStack(spacing: 10) {
                //                                Text("Next")
                //                                    .font(.title)
                //                                    .fontWeight(.bold)
                //                                //Image(systemName: "chevron.right")
                //                            }.foregroundStyle(.black)
                //                        }
                //                }
                
                VStack(spacing: 16) {
                    
                    Text("Login here")
                        .font(.headline)
                
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button(action: {
                        login()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(email.isEmpty || password.isEmpty ? .gray : .blue)
                                .frame(height: 50)
                            
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || isLoading)
                    .animation(.easeInOut, value: isLoading)
                    
                    // Error message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    // Register link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        NavigationLink(
                            destination: RegisterView().environmentObject(authManager)
                        ) {
                            Text("Register here")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.footnote)
                    .padding(.top, 4)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
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


