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
                    .font(.system(size: 14, design: .serif))
                Text("QR Code").tag("QR Code")
                    .font(.system(size: 14, design: .serif))
                Text("Reference View").tag("Reference View")
                    .font(.system(size: 14, design: .serif))
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedTab == "Info" {
                Form {
                    Section("Basic Info"){
                        Text("Name:  \(camera.name ?? "Unknown")")
                            .font(.system(size: 15, design: .serif))
                        Text("Location: \(camera.location ?? "Unknown")")
                            .font(.system(size: 15, design: .serif))
                    }
                    Section("Network Info"){
                        Text("IP Address: \(camera.ipAddress ?? "-")")
                            .font(.system(size: 15, design: .serif))
                        Text("Subnet Mask: \(camera.subnetMask ?? "-")")
                            .font(.system(size: 15, design: .serif))
                        Text("Default Gateway: \(camera.defaultGateway ?? "-")")
                            .font(.system(size: 15, design: .serif))
                    }
                    Section("Admin Info"){
                        Text("User Name: \(camera.userName ?? "-")")
                            .font(.system(size: 15, design: .serif))
                        Text("Password: \(camera.password ?? "-")")
                            .font(.system(size: 15, design: .serif))
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
                            .font(.system(size: 15, design: .serif))
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
                                .font(.system(size: 15, design: .serif))
                                .foregroundStyle(.secondary)
                            Text("Edit the camera to add a reference photo")
                                .font(.system(size: 13, design: .serif))            .foregroundStyle(.secondary)
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
