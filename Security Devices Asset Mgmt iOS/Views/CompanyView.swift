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
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @State private var showNewCompany = false
    
    var body: some View {
        VStack (spacing: 20){
            List {
                ForEach(dataHolder.companies) { company in
                    NavigationLink {

                        CompanyEditView(company: company)
                            .environmentObject(authManager)
                            .environmentObject(dataHolder)
                    } label: {
                        Label(company.name ?? "", systemImage: "building")
                    }
                    .swipeActions {
                        Button(role: .destructive) {

                            dataHolder.deleteCompany(company, viewContext)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }

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

                CompanyAddView()
                    .environmentObject(authManager)
                    .environmentObject(dataHolder)
            }
        }
    }
}
