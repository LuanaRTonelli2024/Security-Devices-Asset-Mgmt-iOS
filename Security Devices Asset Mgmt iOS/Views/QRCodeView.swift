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
    private var QRcode: UIImage{
        generateQRCode(from: data)
    }
    
    var body: some View {
        VStack(spacing: 24){
            Spacer()
            Image(uiImage: QRcode)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 8, x:0, y:4)
            Spacer()
            
            Button {
                printQRCode()
            } label: {
                Label("", systemImage: "printer")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 34)
            Spacer()
        }
    }
    //MARK: PrintCode
    private func printQRCode(){
        let printConfig = UIPrintInfo(dictionary: nil)
        printConfig.jobName = "QR Code"
        printConfig.outputType = .grayscale
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printConfig
        printController.printingItem = QRcode
        printController.present(animated: true)
    }
    
    //MARK: GenerateCode
    
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
