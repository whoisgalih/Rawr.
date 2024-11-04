//
//  SearchPresenter.swift
//  Rawr
//
//  Created by Galih Akbar on 04/11/24.
//

import SwiftUI
import Combine

class SearchPresenter: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []
    private let router = SearchRouter()
    private let searchUseCase: SearchUseCase

    @Published var games: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false

    var title = ""

    init(searchUseCase: SearchUseCase) {
        self.searchUseCase = searchUseCase
    }

    func searchGame() {
        isLoading = true
        searchUseCase.searchGame(by: title)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { games in
                self.games = games
            })
            .store(in: &cancellables)
    }

    func linkBuilder<Content: View>(
        for game: GameModel,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeDetailView(for: game)) { content() }
    }

}
