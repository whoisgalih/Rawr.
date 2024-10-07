//
//  FavoritesViewModel.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//

import Foundation
import CoreData

class FavoritesViewModel: ObservableObject {
    @Published var favoriteGames: [FavoriteGame] = []

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchFavorites()
    }

    func fetchFavorites() {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        do {
            favoriteGames = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite games: \(error)")
        }
    }
}
