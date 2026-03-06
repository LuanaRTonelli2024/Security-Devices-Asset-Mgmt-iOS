//
//  CameraView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import SwiftUI
import CodeScanner

struct CameraView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @StateObject var cameras = CameraViewModel()
    
    let company: Company //companyID
    
    //Toolbar
    @State private var showNewCamera = false
    @State private var isShowingScanner = false
    @State private var showEditCamera = false
    //@State private var selectedCamera: Camera?
    
    //Scan QR code
    @State private var scannedCode: String?
    
    //Filter camera
    //let indices = filteredCameraIndices()
    
    var body: some View {
        VStack{
            List {
                ForEach(cameras.cameraData) { camera in
                    CameraRowView(camera: camera, cameras: cameras, company: company)
                }
                .onDelete(perform: deleteCamera)
            }
        }
        .padding(10)
        .onAppear {
            Task {
                await cameras.fetchCamerasByCompany(token: authManager.token, companyId: company.id ?? "")
            }
        }
        .navigationTitle("Cameras")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showNewCamera = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewCamera) {
            NavigationStack {
                CameraAddView(cameras: cameras, company: company)
                    .environmentObject(authManager)
            }
        }
    }
    
    
    private func deleteCamera(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let cam = cameras.cameraData[index]
                await cameras.deleteCamera(id: cam.id, token: authManager.token)
            }
        }
    }
}

