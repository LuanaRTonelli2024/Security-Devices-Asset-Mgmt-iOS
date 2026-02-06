//
//  ContentView.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Luana Rocca Tonelli on 2026-02-05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        OnBoardingScrenView()
    }
}

#Preview {
    ContentView()
        //.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
