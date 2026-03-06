//
//  CameraRowView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/4/26.
//

import SwiftUI

struct CameraRowView: View {
    
    let camera: Camera
    @ObservedObject var cameras: CameraViewModel
    let company: Company

    var body: some View {
        NavigationLink(
            destination: CameraDetailView(company: company, cameras: cameras, camera: camera)
        ) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "web.camera")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text(camera.name ?? "Unknow")
                        .font(.headline)
                    Text(camera.location ?? "Unknow")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}


