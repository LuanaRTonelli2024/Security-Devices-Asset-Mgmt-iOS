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
    
    
    var body: some View {
        Form {
            Section("Basic Info"){
                TextField("Name: ", text: $newCompanyName)
            }
        }
        .navigationTitle("New Company")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            // Cancel button
//            ToolbarItem(placement: .cancellationAction) {
//                Button("Cancel") {
//                    dismiss()
//                }
//            }
            
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
