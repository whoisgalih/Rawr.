//
//  FavoriteView.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import SwiftUI

struct FavoriteView: View {

    @ObservedObject var presenter: FavoritePresenter

    var body: some View {
        ZStack {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorIndicator
            } else if presenter.favorites.isEmpty {
                emptyFavorites
            } else {
                content
            }
        }.onAppear {
            self.presenter.getFavoriteGames()
        }.navigationBarTitle(
            Text("Favorite Games"),
            displayMode: .automatic
        )
    }

}

extension FavoriteView {
    var loadingIndicator: some View {
        VStack {
            Text("Loading...")
            ProgressView()
        }
    }

    var errorIndicator: some View {
        CustomEmptyView(
            image: "assetSearchNotFound",
            title: presenter.errorMessage
        ).offset(y: 80)
    }

    var emptyFavorites: some View {
        CustomEmptyView(
            image: "assetNoFavorite",
            title: "Your favorite is empty"
        ).offset(y: 80)
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(
                    self.presenter.favorites,
                    id: \.id
                ) { game in
                    self.presenter.linkBuilder(for: game) {
                        GameRow(game: game)
                    }.buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}
