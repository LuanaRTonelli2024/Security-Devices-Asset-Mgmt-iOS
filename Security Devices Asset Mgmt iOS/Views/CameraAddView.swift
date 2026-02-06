//
//  CameraAddView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/19/25.
//

import SwiftUI
import FirebaseCore

struct CameraAddView: View {
    
    let company: Company
    
    @Environment(\.dismiss) var dismiss

    @StateObject var firebaseManager = FirebaseCameraViewModel.shared
    
    //Info Camera
    @State private var newCameraName: String = ""
    @State private var newCameraLocation: String = ""
    @State private var newCameraIPAddress: String = ""
    @State private var newCameraSubnetMask: String = ""
    @State private var newCameraDefaultGateway: String = ""
    @State private var newCameraUserName: String = ""
    @State private var newCameraPassword: String = ""

    @State private var selectedTab = "Info" //picker
    
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
                        TextField("Name: ", text: $newCameraName)
                        TextField("Location: ", text: $newCameraLocation)
                    }
                    Section("Network Info"){
                        TextField("IP Address: ", text: $newCameraIPAddress)
                        TextField("Subnet Mask: ", text: $newCameraSubnetMask)
                        TextField("Default Gateway: ", text: $newCameraDefaultGateway)
                    }
                    Section("Admin Info"){
                        TextField("User Name: ", text: $newCameraUserName)
                        TextField("Password: ", text: $newCameraPassword)
                    }
                    
                    Button ("Save") {
                        firebaseManager.addCamera(
                            name: newCameraName,
                            location: newCameraLocation,
                            ipAddress: newCameraIPAddress,
                            subnetMask: newCameraSubnetMask,
                            defaultGateway: newCameraDefaultGateway,
                            userName: newCameraUserName,
                            password: newCameraPassword,
                            for: company
                        )
                        dismiss()
                    }
                    .disabled(newCameraName.isEmpty || newCameraLocation.isEmpty)
                }
            }
            else if selectedTab == "QR Code" {
                VStack {
                    Text("QR Code will be available after saving.")
                        .font(.headline)
                    Spacer()
                    }
                    .padding()
            }
            else {
                VStack {
                    Text("Reference Camera View is not available.")
                        .font(.headline)
                    Spacer()
                }
                .padding()
            }
        }
        .padding()
    }
}

//#Preview {
//    CameraAddView()
//}
