//
//  GameMapper.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation

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
                rating: result.rating
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
                rating: result.rating
            )
        }
    }

}
