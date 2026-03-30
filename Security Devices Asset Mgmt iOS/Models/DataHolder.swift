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
    
    @Published var isSyncing: Bool = false
    
    @AppStorage("token") private var token: String = ""
    
    private var isApplyingRemoteChanges = false
    
    private lazy var sync: APISync = {
        APISync(baseURL: URL(string: APIConstants.baseURL)!)
    }()
    
    init(_ context: NSManagedObjectContext) {
        refreshAll(context)
        syncAll(context)
    }
    
    func syncAll(_ context: NSManagedObjectContext) {
        syncCompanies(context)
        syncCameras(context)
    }
    
    
    func refreshAll(_ context: NSManagedObjectContext) {
        refreshCompanies(context)
        refreshCameras(context)
    }
    
    
    func syncCompanies(_ context: NSManagedObjectContext) {
        sync.fetchCompanies(context: context) { [weak self] applying in
            DispatchQueue.main.async {
                self?.isApplyingRemoteChanges = applying
                self?.isSyncing = applying
            }
        } onRemoteApplied: { [weak self] in
            DispatchQueue.main.async {
                self?.refreshCompanies(context)
            }
        }
    }
    
    func syncCameras(_ context: NSManagedObjectContext) {
        sync.fetchCameras(context: context) { [weak self] applying in
            DispatchQueue.main.async {
                self?.isApplyingRemoteChanges = applying
                self?.isSyncing = applying
            }
        } onRemoteApplied: { [weak self] in
            DispatchQueue.main.async {
                self?.refreshCameras(context)
            }
        }
    }
    
    
    func refreshCameras(_ context: NSManagedObjectContext) {
        cameras = fetchCameras(context)
    }
    
    func refreshCamerasByC (forCompany company: CompanyEntity, _ context: NSManagedObjectContext){
        cameras = fetchCamerasByC(forCompany: company, context)
    }
    
    func refreshCompanies(_ context: NSManagedObjectContext){
        companies = fetchCompanies(context)
        print("REFRESH COMPANIES COUNT:", companies.count)     }
    
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
        //cam.id = UUID().uuidString
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
    
    
    func saveContext(_ context: NSManagedObjectContext) {
        
        let inserted = context.insertedObjects
        let updated  = context.updatedObjects
        let deleted  = context.deletedObjects
        
        let insertedCameras   = inserted.compactMap { $0 as? CameraEntity }
        let updatedCameras    = updated.compactMap  { $0 as? CameraEntity }
        let deletedCameraIDs  = deleted.compactMap  { ($0 as? CameraEntity)?.id }
        
        let insertedCompanies  = inserted.compactMap { $0 as? CompanyEntity }
        let updatedCompanies   = updated.compactMap  { $0 as? CompanyEntity }
        let deletedCompanyIDs  = deleted.compactMap  { ($0 as? CompanyEntity)?.id }
        
        do {
            try context.save()
            refreshAll(context) // always refresh
            
            guard !isApplyingRemoteChanges else {
                print("Skipping push — applying remote changes")
                return
            }
            
            deletedCameraIDs.forEach  {
                print("API DELETE camera:", $0)
                sync.pushDeleteCamera(cameraID: $0)
            }
            insertedCameras.forEach {
                print("API CREATE camera:", $0.name ?? "nil")
                sync.pushCreateCamera(camera: $0)
            }
            updatedCameras.forEach {
                print("API UPDATE camera:", $0.id ?? "nil")
                sync.pushUpdateCamera(camera: $0)
            }
            
            deletedCompanyIDs.forEach {
                print("API DELETE company:", $0)
                sync.pushDeleteCompany(companyID: $0)
            }
            insertedCompanies.forEach {
                print("API CREATE company:", $0.name ?? "nil")
                sync.pushCreateCompany(company: $0)
            }
            updatedCompanies.forEach {
                print("API UPDATE company:", $0.id ?? "nil")
                sync.pushUpdateCompany(company: $0)
            }
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
