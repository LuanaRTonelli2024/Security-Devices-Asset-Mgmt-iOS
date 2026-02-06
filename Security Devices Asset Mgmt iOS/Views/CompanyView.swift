//
//  CompanyView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/23/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct CompanyView: View {
    
    @StateObject var firebaseManager = FirebaseCompanyViewModel.shared //Firebase
    @State private var showNewCamera = false

    
       
    var body: some View {
        VStack{
            Text("Companies")
                .font(.headline)
                .background(Color(.systemBackground))
            
            List {
                ForEach(firebaseManager.companies) { company in
                    HStack {
                        Text(company.name)
        
                        Spacer()
                    }
                }
            }
            .onAppear {
                firebaseManager.fetchCompanies()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button {
                            showNewCamera = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showNewCamera){
                CompanyAddView()
            }
            //.navigationTitle("Companies")
            .padding()
            
        }
    }
}


//#Preview {
//    CompanyView()
//}
