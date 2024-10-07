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
        favoriteGame.rating = game.rating
        
        // Encode parent platforms to JSON
        if let platformsData = try? JSONEncoder().encode(game.platforms) {
            favoriteGame.platforms = platformsData
        }

        // Background Image
        if let url = URL(string: game.backgroundImage) {
            downloadImage(from: url) { data in
                if let imageData = data {
                    favoriteGame.backgroundImage = imageData

                    do {
                        try context.save()
                        print("Saved game and image to favorites!")
                    } catch {
                        print("Failed to save favorite game: \(error)")
                    }
                }
            }
        } else {
            do {
                try context.save()
                print("Saved game without image to favorites!")
            } catch {
                print("Failed to save favorite game: \(error)")
            }
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

// Helper function to download image from a URL
func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Failed to download image: \(error?.localizedDescription ?? "No error description")")
            completion(nil)
            return
        }
        completion(data)
    }.resume()
}

extension FavoriteGame {
    func toGame() -> Game? {
        guard
            let name = name,
            let slug = slug,
            let released = released,
            let platforms = platforms
        else {
            return nil
        }
        
        return Game(
            id: Int(id),
            slug: slug,
            name: name,
            released: released,
            backgroundImage: "",
            rating: rating,
            parentPlatforms: getPlatforms()
        )
    }
}


extension FavoriteGame {
    func getPlatforms() -> [ParentPlatform] {
        guard let platformsData = self.platforms else {
            return []
        }
        
        do {
            let parentPlatforms = try JSONDecoder().decode([ParentPlatform].self, from: platforms!)
            return parentPlatforms
        } catch {
            print("Failed to decode parent platforms: \(error)")
            return []
        }
    }
}
