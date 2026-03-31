//
//  CameraDetailView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import SwiftUI
import CoreData

struct CameraDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager

//    let company: Company
    let company: CompanyEntity
    let camera: CameraEntity
    
//    @ObservedObject var cameras: CameraViewModel
    
//    let camera: Camera
    //@State var camera: Camera
    //@Binding var camera: Camera
    
    @State private var selectedTab = "Info" //picker
    @State private var showEdit = false //toolbar
    
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Info").tag("Info")
                Text("QR Code").tag("QR Code")
                Text("Reference View").tag("Reference View")
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedTab == "Info" {
                Form {
                    Section("Basic Info"){
                        Text("Name:  \(camera.name ?? "Unknown")")
                        Text("Location: \(camera.location ?? "Unknown")")
                    }
                    Section("Network Info"){
                        Text("IP Address: \(camera.ipAddress ?? "-")")
                        Text("Subnet Mask: \(camera.subnetMask ?? "-")")
                        Text("Default Gateway: \(camera.defaultGateway ?? "-")")
                    }
                    Section("Admin Info"){
                        Text("User Name: \(camera.userName ?? "-")")
                        Text("Password: \(camera.password ?? "-")")
                    }
                }
            }
            else if selectedTab == "QR Code" {
                VStack {
                    //Text("QR Code View")
                    //    .font(.headline)
                    if let id = camera.id {
                        QRCodeView(data: id)
                    } else {
                        Text("Camera ID not available")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            else {
                VStack(spacing: 16) {
                    if let urlString = camera.imageUrl,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 350)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                                .frame(height: 350)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            Text("No reference image yet")
                                .foregroundStyle(.secondary)
                            Text("Edit the camera to add a reference photo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: 350)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEdit = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $showEdit){
            NavigationStack {
                CameraEditView(camera: camera)
                    .environmentObject(authManager)
                    .environmentObject(dataHolder)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
}
