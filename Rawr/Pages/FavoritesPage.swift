//
//  FavoritesPage.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//

import SwiftUI

struct FavoritesPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            entity: FavoriteGame.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteGame.id, ascending: true)]
        ) private var favoriteGames: FetchedResults<FavoriteGame>

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    if !favoriteGames.isEmpty {
                        ForEach(favoriteGames, id: \.self) { favoriteGame in
                            if let game = favoriteGame.toGame() {
                                GameListRow(game, imageData: favoriteGame.backgroundImage)
                                    .padding(.horizontal, 16)
                            }
                            
                        }
                    } else {
                        Text("No favorites found.")
                            .frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
                            .customFont(.caption)
                            .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

extension FavoriteGame {
    @NSManaged public var platforms: [String]
}

extension FavoriteGame {
    func toGame() -> Game? {
        guard
            let name = name,
            let slug = slug,
            let released = released
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
            parentPlatforms: []
        )
    }
}


struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let exampleFavorite = FavoriteGame(context: context)
        exampleFavorite.id = Int64(exampleGame.id)
        exampleFavorite.name = exampleGame.name
        exampleFavorite.slug = exampleGame.slug
        exampleFavorite.released = exampleGame.released
        if let url = URL(string: exampleGame.backgroundImage) {
            downloadImage(from: url) { data in
                if let imageData = data {
                    exampleFavorite.backgroundImage = imageData

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
        exampleFavorite.rating = exampleGame.rating

        return FavoritesPage()
            .environment(\.managedObjectContext, context)
    }
}
