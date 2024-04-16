//
//  PoketDexApp.swift
//  PoketDex
//
//  Created by Aman Giri on 2024-04-15.
//

import SwiftUI

@main
struct PoketDexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
