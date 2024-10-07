//
//  FavoriteManager.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//

import CoreData

class FavoriteManager {
    static func saveGameToFavorites(game: Game, context: NSManagedObjectContext) {
        let favoriteGame = FavoriteGame(context: context)
        favoriteGame.id = Int64(game.id)
        favoriteGame.slug = game.slug
        favoriteGame.name = game.name
        favoriteGame.released = game.released
        favoriteGame.backgroundImage = game.backgroundImage
        favoriteGame.rating = game.rating

        do {
            try context.save()
            print("Saved game to favorites!")
        } catch {
            print("Failed to save favorite game: \(error)")
        }
    }
    
    static func removeGameFromFavorites(game: Game, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", game.id)
        
        do {
            let favoriteGames = try context.fetch(fetchRequest)
            for favoriteGame in favoriteGames {
                context.delete(favoriteGame)
            }
            try context.save()
        } catch {
            print("Failed to remove favorite game: \(error)")
        }
    }

    static func isGameFavorite(game: Game, context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", game.id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check if game is favorite: \(error)")
            return false
        }
    }
}

