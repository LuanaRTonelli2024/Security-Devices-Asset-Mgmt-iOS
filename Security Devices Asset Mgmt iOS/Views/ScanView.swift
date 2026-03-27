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
    @Environment(\.managedObjectContext) private var context
    
    @State private var scannedCode: String?
    @State private var isShowingScanner: Bool = true
    @State private var cameraFound: CameraEntity?
    @State private var ShowCamera: Bool = false
    @State private var notFound: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                if isShowingScanner {
                    CodeScannerView(
                        codeTypes: [.qr],
                        simulatedData: "Loading Camera...",
                        completion: handleScan
                    )
                }
                
                if notFound {
                    VStack(spacing: 16){
                        Text("Camera not found")
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.red)
                        
                        Button("Try again"){
                            notFound = false
                            scannedCode = nil
                            isShowingScanner = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle("Scan QR")
            .navigationDestination(isPresented: $ShowCamera) {
                if let camera = cameraFound {
                    //CameraDetailView(company: <#Company#>, cameras: <#CameraViewModel#>, camera: <#Camera#>)
                }
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            scannedCode = scanResult.string // muda vs o video
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ScanView()
}
