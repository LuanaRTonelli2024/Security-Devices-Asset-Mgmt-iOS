//
//  CompanyView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/23/25.
//

import SwiftUI
import CoreData


struct CompanyView: View {
    
    @EnvironmentObject var authManager: AuthManager
    //@StateObject var companies = CompanyViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    
    //Toolbar
    @State private var showNewCompany = false
    
    var body: some View {
        VStack (spacing: 20){
            List {
                ForEach(dataHolder.companies) { company in
                    NavigationLink {
//                        CompanyEditView(company: company) { newName, newAddress, newContact in
//                            Task {
//                                await companies.updateCompany(
//                                    token: authManager.token,
//                                    id: company.id ?? "",
//                                    newName: newName,
//                                    newAddress: newAddress,
//                                    newContact: newContact
//                                    
//                                )
//                            }
//                        }
                        CompanyEditView(company: company)
                            .environmentObject(authManager)
                            .environmentObject(dataHolder)
                    } label: {
                        Label(company.name ?? "", systemImage: "building")
                    }
                    .swipeActions {
                        Button(role: .destructive) {
//                            Task {
//                                await companies.deleteCompany(token: authManager.token, id: company.id)
//                            }
                            dataHolder.deleteCompany(company, viewContext)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
//        .onAppear {
//            Task {
//                await companies.fetchCompanies(token: authManager.token)
//            }
//        }
        //        .navigationTitle("Companies")
        //        Spacer()
        .onAppear{
            dataHolder.syncAll(viewContext)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
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
//                CompanyAddView(companies: companies)
                CompanyAddView()
                    .environmentObject(authManager)
                    .environmentObject(dataHolder)
            }
        }
    }
}
