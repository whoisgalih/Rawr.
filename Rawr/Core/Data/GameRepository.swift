//
//  MealRepository.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
    func getGames() -> AnyPublisher<[GameModel], Error>
}

final class GameRepository: NSObject {

    typealias GameInstance = (LocaleDataSource, RemoteDataSource) -> GameRepository

    fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocaleDataSource

    private init(locale: LocaleDataSource, remote: RemoteDataSource) {
        self.locale = locale
        self.remote = remote
    }

    static let sharedInstance: GameInstance = { localeRepo, remoteRepo in
        return GameRepository(locale: localeRepo, remote: remoteRepo)
    }

}

extension GameRepository: GameRepositoryProtocol {
    func getGames() -> AnyPublisher<[GameModel], Error> {
        return self.locale.getGames()
            .flatMap { result -> AnyPublisher<[GameModel], Error> in
                if result.isEmpty {
                    return self.remote.getGames()
                        .map { GameMapper.mapGameResponsesToEntities(input: $0) }
                        .catch { _ in self.locale.getGames() }
                        .flatMap { self.locale.addGames(from: $0) }
                        .filter { $0 }
                        .flatMap { _ in self.locale.getGames()
                                .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.locale.getGames()
                        .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
