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
    
    var camera: Camera
    
    @State var name: String
    @State var location: String
    @State var ipAddress: String
    @State var subnetMask: String
    @State var defaultGateway: String
    @State var userName: String
    @State var password: String
    
    var onUpdate: (String, String, String, String, String, String, String) -> Void
    
    init(camera: Camera,
         onUpdate: @escaping (String, String, String, String, String, String, String) -> Void) {
        
        self.camera = camera
        
        _name = State(initialValue: camera.name ?? "")
        _location = State(initialValue: camera.location ?? "")
        _ipAddress = State(initialValue: camera.ipAddress ?? "")
        _subnetMask = State(initialValue: camera.subnetMask ?? "")
        _defaultGateway = State(initialValue: camera.defaultGateway ?? "")
        _userName = State(initialValue: camera.userName ?? "")
        _password = State(initialValue: camera.password ?? "")
        
        self.onUpdate = onUpdate
    }
    
    var body: some View {
        Form {
            Section("Edit Camera") {
                TextField("Name", text: $name)
                TextField("Location", text: $location)
                TextField("IP Address", text: $ipAddress)
                TextField("Subnet Mask", text: $subnetMask)
                TextField("Default Gateway", text: $defaultGateway)
                TextField("User Name", text: $userName)
                SecureField("Password", text: $password)
            }
        }
        //.navigationTitle("Edit Camera")
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onUpdate(name,
                             location,
                             ipAddress,
                             subnetMask,
                             defaultGateway,
                             userName,
                             password)
                    dismiss()
                }
                .disabled(name.isEmpty || location.isEmpty)
            }
        }
    }
}
