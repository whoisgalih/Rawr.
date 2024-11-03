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

    func getGames() -> AnyPublisher<[GameEntity], Error>
    func addGames(from games: [GameEntity]) -> AnyPublisher<Bool, Error>

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

    func getGames() -> AnyPublisher<[GameEntity], any Error> {
        return Future<[GameEntity], Error> { completion in
            if let realm = self.realm {
                let games: Results<GameEntity> = {
                    realm.objects(GameEntity.self)
                }()
                completion(.success(games.toArray(ofType: GameEntity.self)))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }

    func addGames(
        from games: [GameEntity]
    ) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, any Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        for game in games {
                            realm.add(game, update: .all)
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
