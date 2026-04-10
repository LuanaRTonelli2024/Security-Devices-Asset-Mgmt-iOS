//
//  CameraAddView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/19/25.
//

import SwiftUI


struct CameraAddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
//    @ObservedObject var cameras: CameraViewModel
    
//    let company: Company
    
    let company: CompanyEntity
    
    
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
                        TextField("Name: ", text: $newCameraName)
                            .font(.system(size: 15, design: .serif))
                        TextField("Location: ", text: $newCameraLocation)
                            .font(.system(size: 15, design: .serif))
                    }
                    Section("Network Info"){
                        TextField("IP Address: ", text: $newCameraIPAddress)
                            .font(.system(size: 15, design: .serif))
                        TextField("Subnet Mask: ", text: $newCameraSubnetMask)
                            .font(.system(size: 15, design: .serif))
                        TextField("Default Gateway: ", text: $newCameraDefaultGateway)
                            .font(.system(size: 15, design: .serif))
                    }
                    Section("Admin Info"){
                        TextField("User Name: ", text: $newCameraUserName)
                            .font(.system(size: 15, design: .serif))
                        TextField("Password: ", text: $newCameraPassword)
                            .font(.system(size: 15, design: .serif))
                    }
                }
            } else if selectedTab == "QR Code" {
                VStack {
                    Text("QR Code will be available after saving.")
                        .font(.system(size: 17, weight: .semibold, design: .serif))
                    Spacer()
                }
                .padding()
            }
            else {
                VStack {
                    Text("Reference Camera View is not available.")
                        .font(.system(size: 17, weight: .semibold, design: .serif))
                    Spacer()
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save"){
                    
                    dataHolder.createCamera(
                        name: newCameraName,
                        location: newCameraLocation.isEmpty ? nil : newCameraLocation,
                        ipAddress: newCameraIPAddress.isEmpty ? nil : newCameraIPAddress,
                        subnetMask: newCameraSubnetMask.isEmpty ? nil : newCameraSubnetMask,
                        defaultGateway: newCameraDefaultGateway.isEmpty ? nil : newCameraDefaultGateway,
                        userName: newCameraUserName.isEmpty ? nil : newCameraUserName,
                        password: newCameraPassword.isEmpty ? nil : newCameraPassword,
                        companyId: company.id,
                        viewContext
                    )
                    dismiss()
                }
                .font(.system(size: 15, design: .serif))
                .disabled(newCameraName.isEmpty || newCameraLocation.isEmpty)
            }
        }
        .padding()
   }
}
