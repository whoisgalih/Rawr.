//
//  Injection.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import RealmSwift

final class Injection: NSObject {

    private final var inMemory: Bool

    init(_ inMemory: Bool = false) {
        self.inMemory = inMemory
    }

    private func provideRepository() -> GameRepositoryProtocol {
        let configuration: Realm.Configuration
        if inMemory {
            // Using an in-memory identifier so that data won't persist between previews
            configuration = Realm.Configuration(inMemoryIdentifier: "PreviewInMemoryRealm")
        } else {
            configuration = Realm.Configuration.defaultConfiguration
        }

        let realm = try? Realm(configuration: configuration)

        let locale: LocaleDataSource = LocaleDataSource.sharedInstance(realm)
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance

        return GameRepository.sharedInstance(locale, remote)
    }

    func provideHome() -> HomeUseCase {
        let repository = provideRepository()
        return HomeInteractor(repository: repository)
    }

    func provideDetail(game: GameModel) -> DetailUseCase {
        let repository = provideRepository()
        return DetailInteractor(repository: repository, game: game)
    }

    //    func provideMeal(meal: MealModel) -> MealUseCase {
    //        let repository = provideRepository()
    //        return MealInteractor(repository: repository, meal: meal)
    //    }
    //    
    func provideFavorite() -> FavoriteUseCase {
        let repository = provideRepository()
        return FavoriteInteractor(repository: repository)
    }
    //    
    //    func provideSearch() -> SearchUseCase {
    //        let repository = provideRepository()
    //        return SearchInteractor(repository: repository)
    //    }

}
