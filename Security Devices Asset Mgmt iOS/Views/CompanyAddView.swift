//
//  CompanyAddView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/22/25.
//


import SwiftUI


struct CompanyAddView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var companies: CompanyViewModel
    @State private var newCompanyName: String = ""
    @State private var newCompanyAddress: String = ""
    @State private var newCompanyContact: String = ""
    
    
    var body: some View {
        Form {
            Section("Basic Info"){
                TextField("Name: ", text: $newCompanyName)
                TextField("Address: ", text: $newCompanyAddress)
                TextField("Contact: ", text: $newCompanyContact)
            }
        }
        .navigationTitle("New Company")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            // Save button
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await companies.createCompany(token: authManager.token, name: newCompanyName)
                        dismiss()
                    }
                }
                .disabled(newCompanyName.isEmpty)
            }
        }
    }
}
