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
            if self.presenter.games.isEmpty {
                self.presenter.getGames(reset: true)
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
            LazyVStack(spacing: 16) {
                ForEach(self.presenter.games) { game in
                    self.presenter.linkBuilder(for: game) {
                        GameRow(game: game)
                            .onAppear {
                                // Trigger load more when the last game appears
                                if self.presenter.games.last == game {
                                    self.presenter.loadMoreGames()
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 16)
                }

                if presenter.isFetchingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(.vertical, 16)
                }
            }
            .padding(.vertical, 16)
        }
        .refreshable {
            self.presenter.getGames(reset: true)
        }
    }

}

#Preview {
    let homeUseCase: HomeUseCase = Injection.init(true).provideHome()
    let homePresenter: HomePresenter = HomePresenter(homeUseCase: homeUseCase)
    HomeView(presenter: homePresenter)
}
