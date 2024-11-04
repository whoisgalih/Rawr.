//
//  HomeInteractor.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import Combine

protocol HomeUseCase {

    // Fetches the initial set of games. If `reset` is true, it resets the pagination.
    func getGames(reset: Bool) -> AnyPublisher<[GameModel], Error>

    // Loads the next page of games.
    func loadMoreGames() -> AnyPublisher<[GameModel], Error>
}

class HomeInteractor: HomeUseCase {

    private let repository: GameRepositoryProtocol

    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    // Fetches the initial set of games. If `reset` is true, it resets the pagination.
    func getGames(reset: Bool = false) -> AnyPublisher<[GameModel], Error> {
        return repository.getGames(reset: reset)
    }

    // Loads the next page of games.
    func loadMoreGames() -> AnyPublisher<[GameModel], Error> {
        return repository.loadMoreGames()
    }

}
