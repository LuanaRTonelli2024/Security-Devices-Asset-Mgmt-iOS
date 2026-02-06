//
//  QRCodeView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/18/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    let data: String
    
    var body: some View {
            Image(uiImage: generateQRCode(from: data))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
        }
        
        private func generateQRCode(from string: String) -> UIImage {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            let data = Data(string.utf8)
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage,
               let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
            
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
    }


//#Preview {
//    QRCodeView()
//}
