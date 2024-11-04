//
//  GameRepository.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
    func getGames() -> AnyPublisher<[GameModel], Error>
    func getGameDetail(by idGame: Int) -> AnyPublisher<GameDetailModel, Error>

    func getScreenshots(by idGame: Int) -> AnyPublisher<[ScreenshotModel], Error>

    func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
    func updateFavoriteGame(by idGame: Int) -> AnyPublisher<GameModel, Error>

    func searchGame(by name: String) -> AnyPublisher<[GameModel], Error>
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

    func getGameDetail(
        by idGame: Int
    ) -> AnyPublisher<GameDetailModel, Error> {
        return self.locale.getGameDetail(by: idGame)
            .flatMap { result -> AnyPublisher<GameDetailModel, Error> in
                if result == nil {
                    return self.remote.getGameDetail(by: idGame)
                        .map { GameDetailMapper.mapGameDetailResponseToEntity(by: idGame, input: $0) }
//                        .catch { error -> AnyPublisher<GameDetailEntity?, Error> in
//                            return self.locale.getGameDetail(by: idGame)
//                        }
                        .flatMap { self.locale.addGameDetail(gameDetail: $0) }
                        .filter { $0 }
                        .flatMap { _ in self.locale.getGameDetail(by: idGame)
                                .map { GameDetailMapper.mapGameDetailEntityToDomain(input: $0!) }
                        }.eraseToAnyPublisher()
                } else {
                    return self.locale.getGameDetail(by: idGame)
                        .map { GameDetailMapper.mapGameDetailEntityToDomain(input: $0!) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }

    func getScreenshots(
        by idGame: Int
    ) -> AnyPublisher<[ScreenshotModel], Error> {
        return self.locale.getScreenshots()
            .flatMap { result -> AnyPublisher<[ScreenshotModel], Error> in
                if result.isEmpty {
                    return self.remote.getScreenshots(by: idGame)
                        .map { ScreenshotMapper.mapScreenshotResponsesToEntities(input: $0) }
                        .catch { _ in self.locale.getScreenshots() }
                        .flatMap { self.locale.addScreenshots(from: $0) }
                        .filter { $0 }
                        .flatMap { _ in self.locale.getScreenshots()
                                .map { ScreenshotMapper.mapScreenshotEntitiesToDomains(input: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return self.locale.getScreenshots()
                        .map { ScreenshotMapper.mapScreenshotEntitiesToDomains(input: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }

    func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
        return self.locale.getFavoriteGames()
            .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
            .eraseToAnyPublisher()
    }

    func updateFavoriteGame(
        by idGame: Int
    ) -> AnyPublisher<GameModel, Error> {
        return self.locale.updateFavoriteGame(by: idGame)
            .map { GameMapper.mapGameEntityToDomain(input: $0) }
            .eraseToAnyPublisher()
    }

    func searchGame(
      by name: String
    ) -> AnyPublisher<[GameModel], Error> {
      return self.remote.searchGame(by: name)
        .map { GameMapper.mapGameResponsesToEntities(input: $0) }
        .catch { _ -> AnyPublisher<[GameEntity], Error> in
            return self.locale.getGamesBy(name)
        }
        .flatMap { responses  in
          self.locale.getGamesBy(name)
            .flatMap { locale -> AnyPublisher<[GameModel], Error> in
              if responses.count > locale.count {
                return self.locale.addGamesBy(name, from: responses)
                  .filter { $0 }
                  .flatMap { _ in self.locale.getGamesBy(name)
                          .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
                  }.eraseToAnyPublisher()
              } else {
                return self.locale.getGamesBy(name)
                  .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
                  .eraseToAnyPublisher()
              }
            }
        }.eraseToAnyPublisher()
    }
}
