//
//  CompanyAddView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/22/25.
//


import SwiftUI
import FirebaseCore

struct CompanyAddView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var firebaseManager = FirebaseCompanyViewModel.shared
    @State private var newCompanyName: String = ""
    
    
    var body: some View {
        VStack {
            Form {
                Section("Basic Info"){
                    TextField("Name: ", text: $newCompanyName)
                }
                
                
                Button ("Save") {
                    firebaseManager.addCompany(
                        name: newCompanyName
                    )
                    dismiss()
                }
                .disabled(newCompanyName.isEmpty)
            }
        }
    }
}


//#Preview {
//    CompanyAddView()
//}
