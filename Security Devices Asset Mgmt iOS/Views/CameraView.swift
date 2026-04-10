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

    @State private var scannedCode: String?
    
    
    var body: some View {
        VStack{
            List {

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
                Button {
                    showNewCamera = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewCamera) {
            NavigationStack {

                CameraAddView(company: company)
                    .environmentObject(authManager)
            }
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

