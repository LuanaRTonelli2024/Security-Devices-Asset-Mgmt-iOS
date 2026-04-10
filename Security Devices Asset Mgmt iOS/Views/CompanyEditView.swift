//
//  CompanyEditView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/27/26.
//

import SwiftUI
import CoreData
import MapKit

struct CompanyEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var CompanyMVM: CompanyMapViewModel
    
    var company: CompanyEntity
    
    @State var name: String
    @State var address: String
    @State var contact: String
    
    
    init(company: CompanyEntity) {
        self.company = company
        _name    = State(initialValue: company.name    ?? "")
        _address = State(initialValue: company.address ?? "")
        _contact = State(initialValue: company.contact ?? "")
        _CompanyMVM = StateObject(wrappedValue: CompanyMapViewModel(company: company))

    }
    
    var body: some View {
        Form {
            Section("Company Information") {
                TextField("Company name: ", text: $name)
                    .font(.system(size: 15, design: .serif))
                TextField("Address: ", text: $address)
                    .font(.system(size: 15, design: .serif))
                TextField("Contact: ", text: $contact)
                    .font(.system(size: 15, design: .serif))
            }
            Section("Location"){
                if let destination = CompanyMVM.destination {
                        NavigationLink {
                            CompanyMapView(company: company)
                        } label: {
                            Map(position: .constant(.region(MKCoordinateRegion(
                                center: destination,
                                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                            )))) {
                                Marker(company.name ?? "", coordinate: destination)
                                    .tint(.red)
                            }
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(true)
                        }
                    } else {
                        Text("No address available")
                            .font(.system(size: 15, design: .serif))
                            .foregroundStyle(.secondary)
                    }
            }
            Section {
                NavigationLink {
                    CameraView(company: company)
                        .environmentObject(authManager)
                } label: {
                    Label("Cameras", systemImage: "web.camera")
                        .font(.system(size: 15, design: .serif))
                }
            }
        }
        .task {
            await CompanyMVM.geocodeCompanyAddress() //to geoCode the dest.
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    dataHolder.updateCompany(
                        company: company,
                        name: name,
                        address: address.isEmpty ? nil : address,
                        contact: contact.isEmpty ? nil : contact,
                        viewContext
                    )
                    dismiss()
                }
                .font(.system(size: 15, design: .serif))
                .disabled(name.isEmpty)
            }
        }
    }
}

