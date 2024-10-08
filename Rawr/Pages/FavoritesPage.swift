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
                                NavigationLink(
                                    destination: GameDetailPage(
                                        game,
                                        imageData: favoriteGame.backgroundImage
                                    )
                                ) {
                                    GameListRow(game, imageData: favoriteGame.backgroundImage)
                                        .padding(.horizontal, 16)
                                }
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
        .accentColor(.textPrimary)
    }
}

struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        return FavoritesPage()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
