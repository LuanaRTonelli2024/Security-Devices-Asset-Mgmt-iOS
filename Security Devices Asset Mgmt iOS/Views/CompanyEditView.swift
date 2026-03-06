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
    
    var company: Company
    @State var name: String
    
    var onUpdate: (String) -> Void
    
    init(company: Company, onUpdate: @escaping(String) -> Void) {
        self.company = company
        
        _name = State(initialValue: company.name ?? "")
        self.onUpdate = onUpdate
    }
    
    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Company name", text: $name)
            }
        }
        //.navigationTitle("Edit Company")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onUpdate(name)
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
    }
}

