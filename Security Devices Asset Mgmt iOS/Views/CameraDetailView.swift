//
//  CameraDetailView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import SwiftUI

struct CameraDetailView: View {
    
    @EnvironmentObject var authManager: AuthManager

    let company: Company
    
    @ObservedObject var cameras: CameraViewModel
    
    let camera: Camera
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
                VStack {
                    Text("Reference Camera View")
                        .font(.headline)
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
                CameraEditView(camera: camera) { newName, newLocation, newIp, newSubnet, newGateway, newUser, newPass in
                    Task {
                        await cameras.updateCamera(
                            token: authManager.token,
                            id: camera.id ?? "",
                            newName: newName,
                            newLocation: newLocation,
                            newIpAddress: newIp,
                            newSubnetMask: newSubnet,
                            newDefaultGateway: newGateway,
                            newUserName: newUser,
                            newPassword: newPass,
                            for: company
                        )
                    }
                }
            }
        }
    }
}
