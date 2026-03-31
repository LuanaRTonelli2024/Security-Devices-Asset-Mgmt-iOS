//
//  CameraEditView.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/20/25.
//

import SwiftUI
import PhotosUI

struct CameraEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataHolder: DataHolder
    
    @EnvironmentObject var authManager: AuthManager
    
    @Environment(\.dismiss) var dismiss
    
    //    var camera: Camera
    
    var camera: CameraEntity
    
    @State var name: String
    @State var location: String
    @State var ipAddress: String
    @State var subnetMask: String
    @State var defaultGateway: String
    @State var userName: String
    @State var password: String
    
    
    // Image states
    @State private var selectedImage: UIImage? = nil
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var showCamera = false
    @State private var isUploading = false
    @State private var uploadError: String? = nil
    
    
    init(camera: CameraEntity) {
        
        self.camera = camera
        
        _name = State(initialValue: camera.name ?? "")
        _location = State(initialValue: camera.location ?? "")
        _ipAddress = State(initialValue: camera.ipAddress ?? "")
        _subnetMask = State(initialValue: camera.subnetMask ?? "")
        _defaultGateway = State(initialValue: camera.defaultGateway ?? "")
        _userName = State(initialValue: camera.userName ?? "")
        _password = State(initialValue: camera.password ?? "")
    }
    
    var body: some View {
        Form {
            Section("Edit Camera") {
                TextField("Name", text: $name)
                TextField("Location", text: $location)
                TextField("IP Address", text: $ipAddress)
                TextField("Subnet Mask", text: $subnetMask)
                TextField("Default Gateway", text: $defaultGateway)
                TextField("User Name", text: $userName)
                SecureField("Password", text: $password)
            }
            
            Section("Reference Image") {
                            
                            // Preview — selected image or existing from Firebase
                            if let selected = selectedImage {
                                Image(uiImage: selected)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                                    .cornerRadius(10)
                            } else if let urlString = camera.imageUrl,
                                      let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 200)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                        .frame(height: 200)
                                }
                            } else {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                        .foregroundStyle(.secondary)
                                    Text("No reference image yet")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            // Take photo with camera
                            Button {
                                showCamera = true
                            } label: {
                                Label("Take Photo", systemImage: "camera")
                            }
                            
                            // Pick from gallery
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Label("Choose from Gallery", systemImage: "photo.on.rectangle")
                            }
                            .onChange(of: selectedPhoto) { _, item in
                                Task {
                                    if let data = try? await item?.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        selectedImage = image
                                    }
                                }
                            }
                            
                            // Error message
                            if let error = uploadError {
                                Text(error)
                                    .foregroundStyle(.red)
                                    .font(.caption)
                            }
                        }
                    }
                    .sheet(isPresented: $showCamera) {
                        CameraPickerView(selectedImage: $selectedImage)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            // [CHANGED] single Save button — uploads image if selected, then saves
                            Button {
                                saveAll()
                            } label: {
                                if isUploading {
                                    ProgressView()
                                } else {
                                    Text("Save")
                                }
                            }
                            .disabled(name.isEmpty || location.isEmpty || isUploading)
                        }
                    }
                }
                
                // [CHANGED] single save function — uploads image first if needed, then saves camera data
                private func saveAll() {
                    if let image = selectedImage, let cameraId = camera.id {
                        // has new image — upload first, then save
                        isUploading = true
                        uploadError = nil
                        
                        ImageUploader.shared.uploadCameraImage(image: image, cameraId: cameraId) { result in
                            DispatchQueue.main.async {
                                isUploading = false
                                switch result {
                                case .success(let url):
                                    camera.imageUrl = url
                                    print("Image uploaded, URL:", url)
                                    saveCamera()
                                case .failure(let error):
                                    uploadError = "Upload failed: \(error.localizedDescription)"
                                    print("Upload error:", error)
                                }
                            }
                        }
                    } else {
                        // no new image — just save camera data
                        saveCamera()
                    }
                }
                
                private func saveCamera() {
                    dataHolder.updateCamera(
                        camera: camera,
                        name: name,
                        location: location.isEmpty ? nil : location,
                        ipAddress: ipAddress.isEmpty ? nil : ipAddress,
                        subnetMask: subnetMask.isEmpty ? nil : subnetMask,
                        defaultGateway: defaultGateway.isEmpty ? nil : defaultGateway,
                        userName: userName.isEmpty ? nil : userName,
                        password: password.isEmpty ? nil : password,
                        companyId: camera.companyId,
                        viewContext
                    )
                    dismiss()
                }
            }
             
            // Camera picker — opens live camera
            struct CameraPickerView: UIViewControllerRepresentable {
                
                @Binding var selectedImage: UIImage?
                @Environment(\.dismiss) var dismiss
                
                func makeUIViewController(context: Context) -> UIImagePickerController {
                    let picker = UIImagePickerController()
                    picker.delegate = context.coordinator
                    picker.sourceType = .camera
                    return picker
                }
                
                func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
                
                func makeCoordinator() -> Coordinator {
                    Coordinator(self)
                }
                
                class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
                    let parent: CameraPickerView
                    
                    init(_ parent: CameraPickerView) {
                        self.parent = parent
                    }
                    
                    func imagePickerController(_ picker: UIImagePickerController,
                                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                        if let image = info[.originalImage] as? UIImage {
                            parent.selectedImage = image
                        }
                        parent.dismiss()
                    }
                    
                    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                        parent.dismiss()
                    }
                }
            }
