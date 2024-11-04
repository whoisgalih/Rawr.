//
//  LocaleDataStore.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import RealmSwift
import Combine

protocol LocaleDataSourceProtocol: AnyObject {

    func getGames(page: Int) -> AnyPublisher<[GameModel], Error>
    func addGames(from entities: [GameEntity]) -> AnyPublisher<Bool, Error>
    func getGamesBy( _ name: String) -> AnyPublisher<[GameEntity], Error>

    func getGameDetail(by idGame: Int) -> AnyPublisher<GameDetailEntity?, Error>
    func addGameDetail(gameDetail: GameDetailEntity) -> AnyPublisher<Bool, Error>

    func getFavoriteGames() -> AnyPublisher<[GameEntity], Error>
    func updateFavoriteGame(by idGame: Int) -> AnyPublisher<GameEntity, Error>
}

final class LocaleDataSource: NSObject {

    private let realm: Realm?

    private init(realm: Realm?) {
        self.realm = realm
    }

    static let sharedInstance: (Realm?) -> LocaleDataSource = { realmDatabase in
        return LocaleDataSource(realm: realmDatabase)
    }

}

extension LocaleDataSource: LocaleDataSourceProtocol {

    // Fetches games for a specific page from local storage.
    func getGames(page: Int) -> AnyPublisher<[GameModel], Error> {
        return Future<[GameModel], Error> { [weak self] completion in
            guard let self = self, let realm = self.realm else {
                completion(.failure(DatabaseError.invalidInstance))
                return
            }

            let pageSize = 20
            let offset = (page - 1) * pageSize
            let sortedGames = realm.objects(GameEntity.self)
            //                .sorted(byKeyPath: "id", ascending: false) // Adjust sorting as per API's ordering

            if offset < sortedGames.count {
                let end = offset + pageSize
                let slicedGames = sortedGames[offset..<min(end, sortedGames.count)]
                let models = GameMapper.mapGameEntitiesToDomains(input: Array(slicedGames))
                completion(.success(models))
            } else {
                completion(.success([])) // No more games to fetch
            }
        }
        .eraseToAnyPublisher()
    }

    // Adds new games to local storage.
    func addGames(from entities: [GameEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] completion in
            guard let self = self, let realm = self.realm else {
                completion(.failure(DatabaseError.invalidInstance))
                return
            }

            do {
                try realm.write {
                    realm.add(entities, update: .modified) // Prevent duplicates using primary key
                }
                completion(.success(true))
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }
        .eraseToAnyPublisher()
    }

    func getGameDetail(
        by idGame: Int
    ) -> AnyPublisher<GameDetailEntity?, any Error> {
        return Future<GameDetailEntity?, any Error> { completion in
            if let realm = self.realm {
                let games: Results<GameDetailEntity> = {
                    realm.objects(GameDetailEntity.self)
                        .filter("id == %@", idGame)
                }()

                guard let game = games.first else {
                    completion(.success(nil))
                    return
                }

                completion(.success(game))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func addGameDetail(
        gameDetail: GameDetailEntity
    ) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(gameDetail, update: .all)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func getScreenshots() -> AnyPublisher<[ScreenshotEntity], any Error> {
        return Future<[ScreenshotEntity], Error> { completion in
            if let realm = self.realm {
                let screenshots: Results<ScreenshotEntity> = {
                    realm.objects(ScreenshotEntity.self)
                        .sorted(byKeyPath: "id", ascending: true)
                }()
                completion(.success(screenshots.toArray(ofType: ScreenshotEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func addScreenshots(
        from screenshots: [ScreenshotEntity]
    ) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, any Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for screenshot in screenshots {
                            realm.add(screenshot, update: .all)
                        }
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func getFavoriteGames() -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error> { completion in
            if let realm = self.realm {
                let gameEntities = {
                    realm.objects(GameEntity.self)
                        .filter("favorite = \(true)")
                }()
                completion(.success(gameEntities.toArray(ofType: GameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func updateFavoriteGame(
        by idGame: Int
    ) -> AnyPublisher<GameEntity, Error> {
        return Future<GameEntity, Error> { completion in
            if let realm = self.realm, let gameEntity = {
                realm.objects(GameEntity.self).filter("id = \(idGame)")
            }().first {
                do {
                    try realm.write {
                        gameEntity.setValue(!gameEntity.favorite, forKey: "favorite")
                    }
                    completion(.success(gameEntity))
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func getGamesBy(
        _ name: String
    ) -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error> { completion in
            if let realm = self.realm {
                let games: Results<GameEntity> = {
                    realm.objects(GameEntity.self)
                        .filter("name contains[c] %@", name)
                        .sorted(byKeyPath: "name", ascending: true)
                }()
                completion(.success(games.toArray(ofType: GameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func addGamesBy(
        _ name: String,
        from games: [GameEntity]
    ) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for game in games {
                            if let gameEntity = realm.object(ofType: GameEntity.self, forPrimaryKey: game.id) {
                                if gameEntity.name == game.name {
                                    game.favorite = gameEntity.favorite
                                    realm.add(game, update: .all)
                                } else {
                                    realm.add(game, update: .modified)
                                }
                            } else {
                                realm.add(game, update: .modified)
                            }
                        }
                    }
                    completion(.success(true))
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
}

extension Results {

    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }

}
