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
                                GameListRow(game: game)
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
    func toGame() -> Game? {
        guard
            let name = name,
            let slug = slug,
            let released = released,
            let backgroundImage = backgroundImage
        else {
            return nil
        }

        return Game(
            id: Int(id),
            slug: slug,
            name: name,
            released: released,
            backgroundImage: backgroundImage,
            rating: rating,
            parentPlatforms: [] // Assuming this information is not stored in Core Data
        )
    }
}


#Preview {
    FavoritesPage()
}
