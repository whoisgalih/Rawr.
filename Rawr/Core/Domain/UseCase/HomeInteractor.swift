//
//  HomeInteractor.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import Combine

protocol HomeUseCase {

    func getGames() -> AnyPublisher<[GameModel], Error>

}

class HomeInteractor: HomeUseCase {

    private let repository: GameRepositoryProtocol

    required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }

    func getGames() -> AnyPublisher<[GameModel], Error> {
        return repository.getGames()
    }

}
