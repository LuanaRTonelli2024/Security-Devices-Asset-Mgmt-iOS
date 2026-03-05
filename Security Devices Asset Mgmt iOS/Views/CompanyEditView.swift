//
//  CompanyEditView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/27/26.
//

import SwiftUI

struct CompanyEditView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
        
    @ObservedObject var companies: CompanyViewModel
    @State var company: Company
    
    @State private var editedName: String = ""

    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Company name", text: $editedName)
            }
        }
        .navigationTitle("Edit Company")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            editedName = company.name ?? ""
        }
        .toolbar {
            
            //ToolbarItem(placement: .cancellationAction) {
            //    Button("Cancel") { dismiss() }
            //}
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await companies.updateCompany(
                            id: company.id ?? "",
                            newName: company.name ?? "",
                            token: authManager.token
                        )
                        dismiss()
                    }
                }
                .disabled(editedName.isEmpty)
            }
        }
    }
}

