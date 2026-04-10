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
    

    @State private var newCompanyName: String = ""
    @State private var newCompanyAddress: String = ""
    @State private var newCompanyContact: String = ""
    
    
    var body: some View {
        Form {
            Section("Basic Info"){
                TextField("Name: ", text: $newCompanyName)
                    .font(.system(size: 15, design: .serif))
                TextField("Address: ", text: $newCompanyAddress)
                    .font(.system(size: 15, design: .serif))
                TextField("Contact: ", text: $newCompanyContact)
                    .font(.system(size: 15, design: .serif))
            }
        }
        .navigationTitle("New Company")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {

                    dataHolder.createCompany(
                        name: newCompanyName,
                        address: newCompanyAddress.isEmpty ? nil : newCompanyAddress,
                        contact: newCompanyContact.isEmpty ? nil : newCompanyContact,
                        viewContext
                    )
                    dismiss()
                }
                .font(.system(size: 15, design: .serif))
                .disabled(newCompanyName.isEmpty)
            }
        }
    }
}
