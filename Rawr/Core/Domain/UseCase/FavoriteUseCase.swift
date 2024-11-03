//
//  FavoriteUseCase.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import Foundation
import Combine

protocol FavoriteUseCase {

    func getFavoriteGames() -> AnyPublisher<[GameModel], Error>

}

class FavoriteInteractor: FavoriteUseCase {

    private let repository: GameRepositoryProtocol

    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
        return repository.getFavoriteGames()
    }

}
