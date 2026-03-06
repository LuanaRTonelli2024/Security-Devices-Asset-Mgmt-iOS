//
//  CompanyView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/23/25.
//

import SwiftUI


struct CompanyView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @StateObject var companies = CompanyViewModel()
    
    //Toolbar
    @State private var showNewCompany = false
    
    var body: some View {
        VStack (spacing: 20){
            List {
                ForEach(companies.companyData) { company in
                    NavigationLink {
                        CompanyEditView(company: company) { newName in
                                Task {
                                    await companies.updateCompany(
                                        token: authManager.token,
                                        id: company.id ?? "",
                                        newName: newName
                                    )
                                }
                            }
                    } label: {
                        HStack {
                            Text(company.name ?? "")
                            Spacer()
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await companies.deleteCompany(token: authManager.token, id: company.id)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await companies.fetchCompanies(token: authManager.token)
            }
        }
        .navigationTitle("Companies")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button {
                        showNewCompany = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showNewCompany){
            NavigationStack {
                CompanyAddView(companies: companies).environmentObject(authManager)
            }
        }
    }
}
