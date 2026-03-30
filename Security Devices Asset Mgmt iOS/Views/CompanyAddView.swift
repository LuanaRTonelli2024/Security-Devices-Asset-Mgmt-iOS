//
//  CompanyAddView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/22/25.
//


import SwiftUI
import CoreData


struct CompanyAddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager
    
    @Environment(\.dismiss) var dismiss
    
//    @ObservedObject var companies: CompanyViewModel
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
//                    Task {
//                        await companies.createCompany(token: authManager.token, name: newCompanyName)
//                        dismiss()
//                    }
                    
                    dataHolder.createCompany(
                        name: newCompanyName,
                        address: newCompanyAddress.isEmpty ? nil : newCompanyAddress,
                        contact: newCompanyContact.isEmpty ? nil : newCompanyContact,
                        viewContext
                    )
                    dismiss()
                }
                .disabled(newCompanyName.isEmpty)
            }
        }
    }
}
