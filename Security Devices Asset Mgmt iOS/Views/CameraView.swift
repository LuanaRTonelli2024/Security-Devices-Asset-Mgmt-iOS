//
//  CameraView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/17/25.
//
import SwiftUI
import CodeScanner

struct CameraView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    @EnvironmentObject var authManager: AuthManager
    
    let company: CompanyEntity
    
    @State private var showNewCamera = false
    @State private var isShowingScanner = false
    @State private var cameraFound: CameraEntity?
    @State private var showCameraDetail = false
    @State private var notFound = false
    
    var body: some View {
        VStack {
            List {
                if notFound {
                    Text("Camera not found for this QR code.")
                        .foregroundStyle(.red)
                        .font(.system(size: 15, design: .serif))
                }
                ForEach(dataHolder.cameras.filter { $0.companyId == company.id }) { camera in
                    CameraRowView(camera: camera, company: company)
                }
                .onDelete(perform: deleteCamera)
            }
        }
        .padding(10)
        .navigationTitle("Cameras")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        isShowingScanner = true
                        notFound = false
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
        .navigationDestination(isPresented: $showCameraDetail) {
            if let camera = cameraFound {
                CameraDetailView(company: company, camera: camera)
                    .environmentObject(authManager)
                    .environmentObject(dataHolder)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                simulatedData: "eaeTcWrbSaSivtJBlr0v",
                completion: handleScan
            )
        }
        .sheet(isPresented: $showNewCamera) {
            NavigationStack {
                CameraAddView(company: company)
                    .environmentObject(authManager)
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            let scannedId = scanResult.string
            if let camera = dataHolder.cameras.first(where: {
                $0.id == scannedId && $0.companyId == company.id
            }) {
                cameraFound = camera
                showCameraDetail = true
            } else {
                notFound = true
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
            notFound = true
        }
    }
    
    private func deleteCamera(at offsets: IndexSet) {
        let filtered = dataHolder.cameras.filter { $0.companyId == company.id }
        for index in offsets {
            let cam = filtered[index]
            dataHolder.deleteCamera(cam, viewContext)
        }
    }
}
