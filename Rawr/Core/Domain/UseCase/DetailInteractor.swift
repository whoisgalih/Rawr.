//
//  DetailInteractor.swift
//  Rarw
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import Combine

protocol DetailUseCase {

    func getGame() -> GameModel
    func getGameDetail() -> AnyPublisher<GameDetailModel, Error>

}

class DetailInteractor: DetailUseCase {

    private let repository: GameRepositoryProtocol
    private let game: GameModel

    required init(
        repository: GameRepositoryProtocol,
        game: GameModel
    ) {
        self.repository = repository
        self.game = game
    }

    func getGame() -> GameModel {
        return game
    }

    func getGameDetail() -> AnyPublisher<GameDetailModel, Error> {
        return repository.getGameDetail(by: game.id)
    }

}
