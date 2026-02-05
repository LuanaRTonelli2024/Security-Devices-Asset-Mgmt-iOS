//
//  Security_Devices_Asset_Mgmt_iOSApp.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Luana Rocca Tonelli on 2026-02-05.
//

import SwiftUI

@main
struct Security_Devices_Asset_Mgmt_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
