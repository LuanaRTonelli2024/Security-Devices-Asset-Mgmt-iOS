//
//  Camera.swift
//  Security Devices Assets Mgmt
//
//  Created by user285344 on 11/14/25.
//

import Foundation
import FirebaseFirestore

struct Camera: Identifiable, Codable {

    @DocumentID var id: String? //firestone will give the id when we upload the id when we upload it to the server
    var name: String
    var location: String
    //var latitude: Double
    //var longitude: Double
    //var model: String
    //var serialNumber: String
    //var warranty: String
    var ipAddress: String
    var subnetMask: String
    var defaultGateway: String
    //var hostName: String
    var userName: String
    var password: String
    //var switchName: String
    
    //var switchPort: String
    var companyId: String
}

// codable ---> encode and decode your data

// firebase ----> ToDo (Stream of data) --> convert it to a ToDo Model

// App --> Firebase --> ToDo Model ---> Stream of data

// Codable to handle this automatically

 
