//
//  HomePresenter.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import SwiftUI
import Combine

class HomePresenter: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []
    private let router = HomeRouter()
    private let homeUseCase: HomeUseCase

    @Published var games: [GameModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false

    // Pagination flags
    @Published var isFetchingMore: Bool = false

    private var canLoadMore: Bool = true

    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }

    // Fetches games. If `reset` is true, it resets the list.
    func getGames(reset: Bool = false) {
        if reset {
            self.canLoadMore = true
            self.games = []
        }

        guard !isLoading else { return }

        isLoading = true
        homeUseCase.getGames(reset: reset)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] fetchedGames in
                guard let self = self else { return }
                if reset {
                    self.games = fetchedGames
                } else {
                    self.games.append(contentsOf: fetchedGames)
                }
                self.canLoadMore = !fetchedGames.isEmpty
            })
            .store(in: &cancellables)
    }

    // Loads more games when the user scrolls to the bottom.
    func loadMoreGames() {
        guard canLoadMore, !isFetchingMore else { return }
        isFetchingMore = true

        homeUseCase.loadMoreGames()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isFetchingMore = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] fetchedGames in
                guard let self = self else { return }
                self.games.append(contentsOf: fetchedGames)
                self.canLoadMore = !fetchedGames.isEmpty
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
