//
//  DataHolder.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-07.
//

import SwiftUI
import CoreData
import Combine

final class DataHolder: ObservableObject {
    
    @Published var cameras: [CameraEntity] = []
    @Published var companies: [CompanyEntity] = []
    
    init(_ context: NSManagedObjectContext) {
        refreshAll(context)
    }
    
    func refreshAll(_ context: NSManagedObjectContext) {
        refreshCompanies(context)
        refreshCameras(context)
    }
    
    func refreshCameras(_ context: NSManagedObjectContext) {
        cameras = fetchCameras(context)
    }
    
    func refreshCamerasByC (forCompany company: CompanyEntity, _ context: NSManagedObjectContext){
        cameras = fetchCamerasByC(forCompany: company, context)
    }
    
    func refreshCompanies(_ context: NSManagedObjectContext){
        companies = fetchCompanies(context)
    }
    
    //MARK: Fetchers
    //for all cameras
    func fetchCameras(_ context: NSManagedObjectContext) -> [CameraEntity] {
        do { return try context.fetch(camerasFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    //for the company view
    func fetchCamerasByC(forCompany company: CompanyEntity, _ context: NSManagedObjectContext) ->
    [CameraEntity] {
        do {
            return try context.fetch(camerasByCompanyIdFetch(company: company))
        } catch {
            fatalError("Unresolved Error \(error)")
        }
    }
    
    //for the scan
    func fetchCameraById(id: String, _ context: NSManagedObjectContext) ->
    CameraEntity? {
        do {
            return try context.fetch(cameraByIdFetch(id: id)).first
        } catch {
            fatalError("Unresolved Error \(error)")
        }
    }
    
    func fetchCompanies(_ context: NSManagedObjectContext) ->
    [CompanyEntity] {
        do {
            return try context.fetch(companiesFetch())
        } catch {
            fatalError("Unresolved Error \(error)")
        }
    }
    
    
    //MARK: Fetch Requests
    func camerasFetch() -> NSFetchRequest<CameraEntity> {
        let request = CameraEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CameraEntity.name, ascending: true)]
        return request
    }
    
    func camerasByCompanyIdFetch(company: CompanyEntity) -> NSFetchRequest<CameraEntity>{
        let request = CameraEntity.fetchRequest()
        request.predicate = NSPredicate(format: "company == %@", company)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CameraEntity.name, ascending: true)]
        return request
    }
    
    func cameraByIdFetch(id: String) -> NSFetchRequest<CameraEntity>{
        let request = CameraEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return request
    }
    
    func companiesFetch() -> NSFetchRequest<CompanyEntity>{
        let request = CompanyEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CompanyEntity.name, ascending: true)]
        return request
    }
    
    
    //MARK: CRUD Camera
    func createCamera(
        name: String,
        location: String?,
        ipAddress: String?,
        subnetMask: String?,
        defaultGateway: String?,
        userName: String?,
        password: String?,
        companyId: String?,
        _ context: NSManagedObjectContext
    ) {
        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !n.isEmpty else { return }
        
        let cam = CameraEntity(context: context)
        cam.id = UUID().uuidString
        cam.name = n
        cam.location = location
        cam.ipAddress = ipAddress
        cam.subnetMask = subnetMask
        cam.defaultGateway = defaultGateway
        cam.userName = userName
        cam.password = password
        cam.companyId = companyId
        
        saveContext(context)
    }
    
    func updateCamera(
        camera: CameraEntity,
        name: String,
        location: String?,
        ipAddress: String?,
        subnetMask: String?,
        defaultGateway: String?,
        userName: String?,
        password: String?,
        companyId: String?,
        _ context: NSManagedObjectContext
    ) {
        camera.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        camera.location = location
        camera.ipAddress = ipAddress
        camera.subnetMask = subnetMask
        camera.defaultGateway = defaultGateway
        camera.userName = userName
        camera.password = password
        
        saveContext(context)
    }
    
    func deleteCamera(_ camera: CameraEntity, _ context: NSManagedObjectContext) {
        context.delete(camera)
        saveContext(context)
    }
    
    //MARK: CRUD Company
    func createCompany(
        name: String,
        address: String?,
        contact: String?,
        _ context: NSManagedObjectContext
    ) {
        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !n.isEmpty else { return }
        
        let c = CompanyEntity(context: context)
        c.id = UUID().uuidString
        c.name = n
        c.address = address
        c.contact = contact
        
        saveContext(context)
    }
    
    func updateCompany(
        company: CompanyEntity,
        name: String,
        address: String?,
        contact: String?,
        _ context: NSManagedObjectContext
    ) {
        company.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        company.address = address
        company.contact = contact
        
        saveContext(context)
    }
    
    func deleteCompany(
        _ company: CompanyEntity,
        _ context: NSManagedObjectContext
    ) {
        context.delete(company)
        saveContext(context)
    }
    
    
    //MARK: save context
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshAll(context) // always refresh
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
