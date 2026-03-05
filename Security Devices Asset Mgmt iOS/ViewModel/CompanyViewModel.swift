//
//  CompanyViewModel.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by user280043 on 2/24/26.
//


import Foundation
import Combine //Observable Object
    

class CompanyViewModel: ObservableObject {
    
    @Published var companyData = [Company]()
    
    @MainActor
    func fetchCompanies(token: String) async {
        
        guard let response: CompanyResponse = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/companies/",
            method: .GET)
        else{
            return
        }
        
        companyData = response.companies
    }
    
    
    //create
    func createCompany(token: String, name: String) async {
        
        let body = Company(id: nil, name: name)
        
        if let result: Company = await WebService().sendRequest(
            fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/companies/",
            method: .POST,
            body: body
        ) {
            print("created: \(result.id ?? "no id")")
            
            await fetchCompanies(token: token)
        }
    }
    
    
    //delete
    func deleteCompany(id: String?, token: String) async {
        
        guard let id = id else {
            print("Error: Company ID is nil.")
            return
        }

        if let result: DeleteCompanyResponse = await WebService().sendRequest(
               fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/companies/\(id)",
               method: .DELETE
           ) {
               print("Deleted company: \(result.companyId)")
           }
           
        await MainActor.run{
            companyData.removeAll{ $0.id == id}
        }
    }
    
    
    
    //update
    func updateCompany(id: String, newName: String, token: String) async {
        
        let body = Company(id: nil, name: newName)
        
        if let result: Company = await WebService().sendRequest(
               fromUrl: "https://special-meme-x5g5p995xjrf6vv-5000.app.github.dev/companies/\(id)",
               method: .PATCH,
               body: body
           ) {
               print("Updated company: \(result.id ?? "no id")")
           }
        
        await fetchCompanies(token: token)
    }
}

