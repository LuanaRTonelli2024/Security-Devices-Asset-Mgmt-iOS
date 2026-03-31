//
//  APISync.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 3/29/26.
//

import Foundation
import CoreData

final class APISync {
    
    private let baseURL: URL
    private let session: URLSession
    //    private let token: String
    
    //    init(baseURL: URL, token: String, session: URLSession = .shared) {
    //        self.baseURL = baseURL
    //        self.token = token
    //        self.session = session
    //    }
    
    private var token: String {
        UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    private func authorizedRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchCompanies(
        context: NSManagedObjectContext,
        onApplyingRemote: @escaping (Bool) -> Void,
        onRemoteApplied: @escaping () -> Void
    ) {
        let url = baseURL.appendingPathComponent("companies/")
        let request = authorizedRequest(url: url, method: "GET")
        
        DispatchQueue.main.async { onApplyingRemote(true) }
        
        session.dataTask(with: request) { data, response, error in
            if let error {
                print("GET /companies/ error:", error)
                DispatchQueue.main.async { onApplyingRemote(false) }
                return
            }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let data else {
                print("GET /companies/ failed")
                DispatchQueue.main.async { onApplyingRemote(false) }
                return
            }
            do {
                let response = try JSONDecoder().decode(CompaniesResponse.self, from: data)
                let dtos = response.companies
                print("REMOTE COMPANIES COUNT:", dtos.count)
                context.perform {
                    self.mergeRemoteCompanies(dtos, into: context)
                    try? context.save()
                    DispatchQueue.main.async {
                        onApplyingRemote(false)
                        onRemoteApplied()
                    }
                }
            } catch {
                print("GET /companies/ decode error:", error)
                DispatchQueue.main.async { onApplyingRemote(false) }
            }
        }.resume()
    }
    
    
    func fetchCameras(
        context: NSManagedObjectContext,
        onApplyingRemote: @escaping (Bool) -> Void,
        onRemoteApplied: @escaping () -> Void
    ) {
        let url = baseURL.appendingPathComponent("cameras/")
        let request = authorizedRequest(url: url, method: "GET")
        
        DispatchQueue.main.async { onApplyingRemote(true) }
        
        session.dataTask(with: request) { data, response, error in
            if let error {
                print("GET /cameras/ error:", error)
                DispatchQueue.main.async { onApplyingRemote(false) }
                return
            }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let data else {
                print("GET /cameras/ failed")
                DispatchQueue.main.async { onApplyingRemote(false) }
                return
            }
            do {
                let response = try JSONDecoder().decode(CamerasResponse.self, from: data)
                let dtos = response.cameras
                print("REMOTE CAMERAS COUNT:", dtos.count)
                context.perform {
                    self.mergeRemoteCameras(dtos, into: context)
                    try? context.save()
                    DispatchQueue.main.async {
                        onApplyingRemote(false)
                        onRemoteApplied()
                    }
                }
            } catch {
                print("GET /cameras/ decode error:", error)
                DispatchQueue.main.async { onApplyingRemote(false) }
            }
        }.resume()
    }
    
    
    func pushCreateCamera(camera: CameraEntity) {
        guard let body = try? JSONEncoder().encode(CameraCreateRequest(from: camera)) else {
            print("pushCreateCamera: encode failed")
            return
        }
        
        var request = authorizedRequest(url: baseURL.appendingPathComponent("cameras/"), method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            if let error { print("POST /cameras/ error:", error); return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let data else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("POST /cameras/ failed:", body)
                return
            }
            guard let dto = try? JSONDecoder().decode(CameraCreateResponse.self, from: data) else {
                print("POST /cameras/ decode response failed")
                return
            }
            guard let context = camera.managedObjectContext else { return }
            context.perform {
                camera.id = dto.id
                try? context.save()
                print("Camera created on server, id:", dto.id ?? "nil")
            }
        }.resume()
    }
    
    
    func pushUpdateCamera(camera: CameraEntity, onSuccess: (() -> Void)? = nil) {
        guard let id = camera.id else {
            print("pushUpdateCamera: missing id")
            return
        }
        guard let body = try? JSONEncoder().encode(CameraUpdateRequest(from: camera)) else {
            print("pushUpdateCamera: encode failed")
            return
        }
        
        var request = authorizedRequest(
            url: baseURL.appendingPathComponent("cameras/\(id)"),
            method: "PATCH"
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            if let error { print("PATCH /cameras/\(id) error:", error); return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("PATCH /cameras/\(id) failed:", body)
                return
            }
            print("PATCH /cameras/\(id) success")
            DispatchQueue.main.async { onSuccess?() }
        }.resume()
    }
    
    
    func pushDeleteCamera(cameraID: String, onSuccess: (() -> Void)? = nil) {
        let request = authorizedRequest(
            url: baseURL.appendingPathComponent("cameras/\(cameraID)"),
            method: "DELETE"
        )
        session.dataTask(with: request) { data, response, error in
            if let error { print("DELETE /cameras/\(cameraID) error:", error); return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("DELETE /cameras/\(cameraID) failed:", body)
                return
            }
            print("DELETE /cameras/\(cameraID) success")
            DispatchQueue.main.async { onSuccess?() }
        }.resume()
    }
    
    
    func pushCreateCompany(company: CompanyEntity) {
        guard let body = try? JSONEncoder().encode(CompanyCreateRequest(from: company)) else {
            print("pushCreateCompany: encode failed")
            return
        }
        
        var request = authorizedRequest(url: baseURL.appendingPathComponent("companies/"), method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            if let error { print("POST /companies/ error:", error); return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let data else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("POST /companies/ failed:", body)
                return
            }
            guard let dto = try? JSONDecoder().decode(CompanyCreateResponse.self, from: data) else {
                print("POST /companies/ decode response failed")
                return
            }
            guard let context = company.managedObjectContext else { return }
            context.perform {
                company.id = dto._id
                try? context.save()
                print("Company created on server, id:", dto._id ?? "nil")
            }
        }.resume()
    }
    
    
    func pushUpdateCompany(company: CompanyEntity, onSuccess: (() -> Void)? = nil) {
        guard let id = company.id else {
            print("pushUpdateCompany: missing id")
            return}
        
        guard let body = try? JSONEncoder().encode(CompanyUpdateRequest(from: company)) else {
            print("pushUpdateCompany: encode failed")
            return
        }
        
        var request = authorizedRequest(
            url: baseURL.appendingPathComponent("companies/\(id)"),
            method: "PATCH"
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        session.dataTask(with: request) { data, response, error in
            if let error { print("PATCH /companies/\(id) error:", error); return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("PATCH /companies/\(id) failed:", body)
                return
            }
            print("PATCH /companies/\(id) success")
            DispatchQueue.main.async { onSuccess?() }
        }.resume()
    }
    
    // MARK: - Push Delete Company
    
    func pushDeleteCompany(companyID: String, onSuccess: (() -> Void)? = nil) {
        let request = authorizedRequest(
            url: baseURL.appendingPathComponent("companies/\(companyID)"),
            method: "DELETE"
        )
        session.dataTask(with: request) { data, response, error in
            if let error { print("DELETE /companies/\(companyID) error:", error); return }
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("DELETE /companies/\(companyID) failed:", body)
                return
            }
            print("DELETE /companies/\(companyID) success")
            DispatchQueue.main.async { onSuccess?() }
        }.resume()
    }
    
    // MARK: - Merge Remote → CoreData
    
    private func mergeRemoteCompanies(_ dtos: [CompanyDTO], into context: NSManagedObjectContext) {
        let request = CompanyEntity.fetchRequest()
        let locals = (try? context.fetch(request)) ?? []
        var localByID: [String: CompanyEntity] = [:]
        for item in locals {
            guard let id = item.id else { continue }
            localByID[id] = item
        }
        for dto in dtos {
            guard let id = dto.id else { continue }
            let entity = localByID[id] ?? CompanyEntity(context: context)
            entity.id = id
            entity.name = dto.name
            entity.address = dto.address
            entity.contact = dto.contact
        }
        print("Merged \(dtos.count) remote companies into CoreData")
    }
    
    private func mergeRemoteCameras(_ dtos: [CameraDTO], into context: NSManagedObjectContext) {
        let request = CameraEntity.fetchRequest()
        let locals = (try? context.fetch(request)) ?? []
        var localByID: [String: CameraEntity] = [:]
        for item in locals {
            guard let id = item.id else { continue }
            localByID[id] = item
        }
        for dto in dtos {
            guard let id = dto.id else { continue }
            let entity = localByID[id] ?? CameraEntity(context: context)
            entity.id = id
            entity.name = dto.name
            entity.location = dto.location
            entity.ipAddress = dto.ipAddress
            entity.subnetMask = dto.subnetMask
            entity.defaultGateway = dto.defaultGateway
            entity.userName = dto.userName
            entity.password = dto.password
            entity.companyId = dto.companyId
        }
        print("Merged \(dtos.count) remote cameras into CoreData")
    }
}

// MARK: - GET Response Wrappers

private struct CamerasResponse: Codable {
    let cameras: [CameraDTO]
}

private struct CompaniesResponse: Codable {
    let companies: [CompanyDTO]
}

// MARK: - POST Response Bodies

private struct CameraCreateResponse: Codable {
    let id: String?
}

private struct CompanyCreateResponse: Codable {
    let _id: String?
}
