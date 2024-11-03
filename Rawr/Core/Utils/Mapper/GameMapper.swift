//
//  GameMapper.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import RealmSwift

final class GameMapper {

    static func mapGameResponsesToEntities(
        input gameResponses: [GameResponse]
    ) -> [GameEntity] {
        return gameResponses.map { result in
            let newGame = GameEntity()
            newGame.id = result.id
            newGame.slug = result.slug
            newGame.name = result.name
            newGame.released = result.released
            newGame.backgroundImage = result.backgroundImage ?? "Unknown"
            newGame.rating = result.rating

            newGame.platforms = List<ParentPlatformEntity>()
            result.parentPlatforms.forEach { platform in
                let newParentPlatform = ParentPlatformEntity()
                newParentPlatform.id = platform.platform.id
                newParentPlatform.name = platform.platform.name
                newParentPlatform.slug = platform.platform.slug

                newGame.platforms.append(newParentPlatform)
            }

            return newGame
        }
    }

    static func mapGameEntitiesToDomains(
        input gameEntities: [GameEntity]
    ) -> [GameModel] {
        return gameEntities.map { result in
            return GameModel(
                id: result.id,
                slug: result.slug,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                platforms: result.platforms.map { platform in
                    ParentPlatformModel(
                        id: platform.id,
                        name: platform.name,
                        slug: platform.slug
                    )
                }
            )
        }
    }

    static func mapGameResponsesToDomains(
        input gameResponses: [GameResponse]
    ) -> [GameModel] {

        return gameResponses.map { result in
            GameModel(
                id: result.id,
                slug: result.slug,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage ?? "Unknown",
                rating: result.rating,
                platforms: result.parentPlatforms.map { response in
                    ParentPlatformModel(
                        id: response.platform.id,
                        name: response.platform.name,
                        slug: response.platform.slug
                    )
                }
            )
        }
    }

}
