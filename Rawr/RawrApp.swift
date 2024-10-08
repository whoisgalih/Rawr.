//
//  RawrApp.swift
//  Rawr
//
//  Created by Galih Akbar on 18/09/22.
//

import SwiftUI

@main
struct RawrApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var userModel = UserModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userModel)
        }
    }
}
