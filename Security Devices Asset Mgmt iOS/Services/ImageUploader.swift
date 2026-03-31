//
//  ImageUploader.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/30/26.
//

import Foundation
import FirebaseStorage
import UIKit
 
final class ImageUploader {
    
    static let shared = ImageUploader()
    private init() {}
    
    // Upload image to Firebase Storage and return download URL
    func uploadCameraImage(
        image: UIImage,
        cameraId: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(UploadError.invalidImage))
            return
        }
        
        let path = "cameras/\(cameraId)/reference.jpg"
        let storageRef = Storage.storage().reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        print("Uploading image to:", path)
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error {
                print("Upload failed:", error)
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error {
                    print("Failed to get download URL:", error)
                    completion(.failure(error))
                    return
                }
                
                guard let url else {
                    completion(.failure(UploadError.invalidURL))
                    return
                }
                
                print("Upload success, URL:", url.absoluteString)
                completion(.success(url.absoluteString))
            }
        }
    }
    
    enum UploadError: Error {
        case invalidImage
        case invalidURL
    }
}
 
