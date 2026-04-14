//
//  ScanView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-07.
//
import SwiftUI
import CoreData
import CodeScanner

struct ScanView: View {
    
    @EnvironmentObject private var Holder: DataHolder
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.managedObjectContext) private var context
    
    @State private var isShowingScanner: Bool = true
    @State private var cameraFound: CameraEntity?
    @State private var companyFound: CompanyEntity?
    @State private var showCamera: Bool = false
    @State private var notFound: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isShowingScanner {
                    CodeScannerView(
                        codeTypes: [.qr],
                        simulatedData: "lkKPmhUteaY4WPgxi15B",
                        completion: handleScan
                    )
                }
                
                if notFound {
                    VStack(spacing: 16) {
                        Text("Camera not found")
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 17, design: .serif))
                            .foregroundStyle(.red)
                        
                        Button("Try again") {
                            notFound = false
                            isShowingScanner = true
                        }
                        .font(.system(size: 15, design: .serif))
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle("Scan QR")
            .onAppear {
                isShowingScanner = true
                notFound = false
                cameraFound = nil
                companyFound = nil
                showCamera = false
            }
            .navigationDestination(isPresented: $showCamera) {
                if let camera = cameraFound, let company = companyFound {
                    CameraDetailView(company: company, camera: camera)
                        .environmentObject(authManager)
                        .environmentObject(Holder)
                        .environment(\.managedObjectContext, context)
                }
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            lookupCamera(by: scanResult.string)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
            notFound = true
        }
    }
    
    func lookupCamera(by id: String) {
        let request: NSFetchRequest<CameraEntity> = CameraEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            if let camera = results.first, let companyId = camera.companyId {
                
                let companyRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
                companyRequest.predicate = NSPredicate(format: "id == %@", companyId)
                companyRequest.fetchLimit = 1
                
                let companies = try context.fetch(companyRequest)
                if let company = companies.first {
                    cameraFound = camera
                    companyFound = company
                    showCamera = true
                } else {
                    notFound = true
                }
            } else {
                notFound = true
            }
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            notFound = true
        }
    }
}
