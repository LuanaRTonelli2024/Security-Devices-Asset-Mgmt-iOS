//
//  CameraEditView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/20/25.
//

import SwiftUI

struct CameraEditView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var cameras: CameraViewModel
    @State var camera: Camera
    let company: Company
    
    @State private var selectedTab = "Info" //picker
    
    @State private var editedName: String = ""
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Info").tag("Info")
                //Text("QR Code").tag("QR Code")
                Text("Reference View").tag("Reference View")
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedTab == "Info" {
                Form {
                    Section("Basic Info"){
                        HStack {
                            Text("Name: ")
                            TextField("", text: $editedName)
                        }
                        HStack {
                            Text("Location: ")
                            //TextField("", text: $camera.location)
                        }
                    }
                    Section("Network Info"){
                        HStack{
                            Text("IP Address: ")
                            //TextField("", text: $camera.ipAddress)
                        }
                        HStack {
                            Text("Subnet Mask: ")
                            //TextField("", text: $camera.subnetMask)
                        }
                        HStack{
                            Text("Default Gateway: ")
                            //TextField("", text: $camera.defaultGateway)
                        }
                    }
                    Section("Admin Info"){
                        HStack{
                            Text("User Name: ")
                            //TextField("", text: $camera.userName)
                        }
                        HStack {
                            Text("Password: ")
                            //TextField("", text: $camera.password)
                        }
                    }
                }
                .navigationTitle("Edit Camera")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button ("Save") {
                            Task {
                                await cameras.updateCamera(
                                    id: camera.id ?? "",
                                    newName: camera.name ?? "",
                                    token: authManager.token
                                )
                                dismiss()
                            }
                        }
                        .disabled(camera.name.isEmpty || camera.location.isEmpty)
                    }
                }
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
    }
}
