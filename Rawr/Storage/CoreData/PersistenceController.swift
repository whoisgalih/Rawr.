//
//  File.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Rawr") // Replace "Rawr" with your .xcdatamodeld filename

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Failed to load persistent store: \(error), \(error.userInfo)")
            } else {
                print("Successfully loaded persistent store: \(storeDescription)")
            }
        }

    }

    // For Previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        FavoriteManager.saveGameToFavorites(game: exampleGame, context: viewContext)

        return controller
    }()
}
