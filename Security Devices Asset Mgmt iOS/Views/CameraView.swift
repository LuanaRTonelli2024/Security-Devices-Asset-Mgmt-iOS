//
//  CameraView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//

import SwiftUI
import FirebaseCore
import CodeScanner

struct CameraView: View {
    
    let company: Company //companyID
    
    @StateObject var firebaseManager = FirebaseCameraViewModel.shared //Firebase
    //Toolbar
    @State private var showNewCamera = false
    @State private var isShowingScanner = false
    //Scan QR code
    @State private var scannedCode: String?
    
    
    var body: some View {
        VStack{
            List {
                if filteredCameraIndices.isEmpty, scannedCode != nil {
                    Text("No camera found for this QR code.")
                        .foregroundColor(.red)
                } else {
                    ForEach(filteredCameraIndices, id: \.self) { index in
                        NavigationLink(
                            destination: CameraDetailView(company: company, camera: $firebaseManager.cameras[index])
                        ) {
                            HStack(alignment: .center, spacing: 12){
                                Image(systemName: "web.camera")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.blue)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(firebaseManager.cameras[index].name)
                                        .font(.headline)
                                    Text(firebaseManager.cameras[index].location)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteCamera)
                }
            }
        }
        .onAppear {
            firebaseManager.fetchCamerasCompany(for: company)
        }
        .onChange(of: firebaseManager.cameras.count) {
            if scannedCode != nil {
                scannedCode = nil
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Button {
                        isShowingScanner = true
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    Button {
                        showNewCamera = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showNewCamera){
            CameraAddView(company: company)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                simulatedData: "gmssxysHg6SDXix2o9Gg",
                completion: handleScan
            )
        }
        .navigationTitle("Cameras")
        .padding()
    }
    
    private func deleteCamera(at offsets: IndexSet) {
        offsets.forEach { index in
            let camera = firebaseManager.cameras[index]
            
            firebaseManager.deleteCamera(camera: camera)
        }
    }
    
    private var filteredCameraIndices: [Int] {
        if let scannedCode = scannedCode,
           let camera = firebaseManager.getCameraById(scannedCode),
           let index = firebaseManager.cameras.firstIndex(where: { $0.id == camera.id }) {
            return [index]
        } else if scannedCode != nil {
            return []
        } else {
            return Array(firebaseManager.cameras.indices)
        }
    }

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            scannedCode = scanResult.string
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}


//#Preview {
//    CameraView()
//}
