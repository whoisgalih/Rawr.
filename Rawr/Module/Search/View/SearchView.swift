//
//  SearchView.swift
//  Rawr
//
//  Created by Galih Akbar on 04/11/24.
//

import SwiftUI

struct SearchView: View {

    @ObservedObject var presenter: SearchPresenter

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if presenter.isLoading {
                    loadingIndicator
                } else if presenter.title.isEmpty {
                    emptyTitle
                } else if presenter.games.isEmpty {
                    emptyGames
                } else if presenter.isError {
                    errorIndicator
                } else {
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
            }.searchable(text: $presenter.title)
                .onSubmit(of: .search, presenter.searchGame)
            Spacer()
        }.navigationBarTitle(
            Text("Search Games"),
            displayMode: .automatic
        )
    }
}

extension SearchView {

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

    var emptyTitle: some View {
        CustomEmptyView(
            image: "assetSearchGame",
            title: "Come on, find your favorite food!"
        ).offset(y: 50)
    }
    var emptyGames: some View {
        CustomEmptyView(
            image: "assetSearchNotFound",
            title: "Data not found"
        ).offset(y: 80)
    }

}

#Preview {
    let searchUseCase: SearchUseCase = Injection.init(true).provideSearch()
    let searchPresenter: SearchPresenter = SearchPresenter(searchUseCase: searchUseCase)
    SearchView(presenter: searchPresenter)
}
