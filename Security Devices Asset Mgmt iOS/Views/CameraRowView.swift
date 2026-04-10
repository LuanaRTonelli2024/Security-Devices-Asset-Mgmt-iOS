//
//  CameraRowView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/4/26.
//

import SwiftUI

struct CameraRowView: View {

    let camera: CameraEntity

    let company: CompanyEntity

    var body: some View {
        NavigationLink(
            
            destination: CameraDetailView(company: company, camera: camera)
        ) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "web.camera")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text(camera.name ?? "Unknow")
                        .font(.system(size: 17, weight: .semibold, design: .serif))
                    Text(camera.location ?? "Unknow")
                        .font(.system(size: 15, design: .serif))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}


