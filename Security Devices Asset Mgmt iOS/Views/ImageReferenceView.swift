//
//  ImageReferenceView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-09.
//

import SwiftUI

struct ImageReferenceView: View {
    var body: some View {
        VStack(spacing: 24){
            Spacer()
            
            HStack{
                Button{
                    
                } label: {
                    Label("Add Image", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    ImageReferenceView()
}
