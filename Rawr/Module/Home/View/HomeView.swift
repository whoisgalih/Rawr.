//
//  HomeView.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter

    var body: some View {
        ZStack {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorIndicator
            } else if presenter.games.isEmpty {
                emptyGame
            } else {
                content
            }
        }.onAppear {
            if self.presenter.games.count == 0 {
                self.presenter.getGames()
            }
        }.navigationBarTitle(
            Text("Rawr"),
            displayMode: .automatic
        )
    }
}

extension HomeView {

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

    var emptyGame: some View {
        CustomEmptyView(
            image: "assetNoFavorite",
            title: "The game is empty"
        ).offset(y: 80)
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(
                    self.presenter.games,
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

#Preview {
    let homeUseCase: HomeUseCase = Injection.init().provideHome()
    let homePresenter: HomePresenter = HomePresenter(homeUseCase: homeUseCase)
    HomeView(presenter: homePresenter)
}
