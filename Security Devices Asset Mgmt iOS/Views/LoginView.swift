//
//  LoginView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20){
            //Spacer()
            Text("Please fill in the fields below")
                .font(.headline)

            
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
            
            SecureField("Enter password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            Button(action: {
                print("Login clicked")
                guard Validators.isEmailValid(email) else {
                    self.errorMessage = "Invalid Email"
                    return
                }
                guard Validators.isValidPassword(password) else {
                    self.errorMessage = "Invalid Password"
                    return
                }
                authManager.login(email: email, password: password) { result in
                    switch result {
                    case .success:
                        self.errorMessage = nil
                    case .failure(let failure):
                        self.errorMessage = failure.localizedDescription
                    }
                }
            }){
                RoundedRectangle(cornerRadius: 10)
                    .fill(email.isEmpty || password.isEmpty ? .gray : .blue)
                    //.fill(.blue)
                    .frame(height: 50)
                    .overlay(
                        Text("Login")
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                
            }
            .disabled(email.isEmpty || password.isEmpty)
            .padding(.horizontal)
            
            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }
            
            NavigationLink(destination: RegisterView()) {
                Text("Don't have an account? Register here")
                    .font(.footnote)
                    .foregroundStyle(.blue)
            }
            
            Spacer()
        }
        .padding()
    }
}


//#Preview {
//    LoginView()
//}
