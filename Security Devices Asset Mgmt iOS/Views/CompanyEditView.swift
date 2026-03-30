//
//  CompanyEditView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/27/26.
//

import SwiftUI
import CoreData

struct CompanyEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager
    
    @Environment(\.dismiss) var dismiss
    
//    var company: Company
    var company: CompanyEntity
    
    @State var name: String
    @State var address: String
    @State var contact: String
    
//    var onUpdate: (String, String?, String?) -> Void
//    
//    init(company: Company, onUpdate: @escaping(String, String?, String?) -> Void) {
//        self.company = company
//        
//        _name = State(initialValue: company.name ?? "")
//        _address = State(initialValue: company.address ?? "")
//        _contact = State(initialValue: company.contact ?? "")
//        self.onUpdate = onUpdate
//    }
    
    init(company: CompanyEntity) {
        self.company = company
        _name    = State(initialValue: company.name    ?? "")
        _address = State(initialValue: company.address ?? "")
        _contact = State(initialValue: company.contact ?? "")
    }
    
    var body: some View {
        Form {
            Section("Company Information") {
                TextField("Company name: ", text: $name)
                TextField("Address: ", text: $address)
                TextField("Contact: ", text: $contact)
            }
            Section("Location"){
                // mapkit
            }
            Section {
                NavigationLink {
                    CameraView(company: company)
                        .environmentObject(authManager)
                } label: {
                    Label("Cameras", systemImage: "web.camera")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
//                    onUpdate(name, address.isEmpty ? nil : address, contact.isEmpty ? nil : contact)
                    dataHolder.updateCompany(
                        company: company,
                        name: name,
                        address: address.isEmpty ? nil : address,
                        contact: contact.isEmpty ? nil : contact,
                        viewContext
                    )
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
    }
}

