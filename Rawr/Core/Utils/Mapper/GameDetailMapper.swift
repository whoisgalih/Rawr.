//
//  GameDetailMapper.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import Foundation
import RealmSwift

final class GameDetailMapper {

    static func mapGameDetailResponseToEntity(
        by idGame: Int,
        input gameDetailResponse: GameDetailResponse
    ) -> GameDetailEntity {
        let newGameDetail = GameDetailEntity()
        newGameDetail.id = idGame
        newGameDetail.welcomeDescription = gameDetailResponse.welcomeDescription
        newGameDetail.updated = gameDetailResponse.updated
        newGameDetail.website = gameDetailResponse.website
        newGameDetail.playtime = gameDetailResponse.playtime
        newGameDetail.screenshotsCount = gameDetailResponse.screenshotsCount
        newGameDetail.moviesCount = gameDetailResponse.moviesCount
        newGameDetail.creatorsCount = gameDetailResponse.creatorsCount
        newGameDetail.achievementsCount = gameDetailResponse.achievementsCount
        newGameDetail.parentAchievementsCount = gameDetailResponse.parentAchievementsCount
        newGameDetail.descriptionRaw = gameDetailResponse.descriptionRaw

        if let esrbRating = gameDetailResponse.esrbRating {
            let newEsrbRating = EsrbRatingEntity()
            newEsrbRating.id = esrbRating.id
            newEsrbRating.name = esrbRating.name
            newEsrbRating.slug = esrbRating.slug
            newGameDetail.esrbRating = newEsrbRating
        }

        newGameDetail.developers = List<DeveloperEntity>()
        gameDetailResponse.developers.forEach { developer in
            let newDeveloper = DeveloperEntity()
            newDeveloper.id = developer.id
            newDeveloper.name = developer.name
            newDeveloper.slug = developer.slug
            newDeveloper.gamesCount = developer.gamesCount
            newDeveloper.imageBackground = developer.imageBackground
            newDeveloper.domain = developer.domain
            newGameDetail.developers.append(newDeveloper)
        }

        newGameDetail.genres = List<DeveloperEntity>()
        gameDetailResponse.genres.forEach { genre in
            let newGenre = DeveloperEntity()
            newGenre.id = genre.id
            newGenre.name = genre.name
            newGenre.slug = genre.slug
            newGenre.gamesCount = genre.gamesCount
            newGenre.imageBackground = genre.imageBackground
            newGenre.domain = genre.domain
            newGameDetail.genres.append(newGenre)
        }

        newGameDetail.tags = List<DeveloperEntity>()
        gameDetailResponse.tags.forEach { tag in
            let newTag = DeveloperEntity()
            newTag.id = tag.id
            newTag.name = tag.name
            newTag.slug = tag.slug
            newTag.gamesCount = tag.gamesCount
            newTag.imageBackground = tag.imageBackground
            newTag.domain = tag.domain
            newGameDetail.tags.append(newTag)
        }

        newGameDetail.publishers = List<DeveloperEntity>()
        gameDetailResponse.publishers.forEach { publisher in
            let newPublisher = DeveloperEntity()
            newPublisher.id = publisher.id
            newPublisher.name = publisher.name
            newPublisher.slug = publisher.slug
            newPublisher.gamesCount = publisher.gamesCount
            newPublisher.imageBackground = publisher.imageBackground
            newPublisher.domain = publisher.domain
            newGameDetail.publishers.append(newPublisher)
        }

        return newGameDetail
    }

    static func mapGameDetailEntityToDomain(
        input gameDetailEntities: GameDetailEntity
    ) -> GameDetailModel {
        return GameDetailModel(
            id: gameDetailEntities.id,
            welcomeDescription: gameDetailEntities.welcomeDescription,
            updated: gameDetailEntities.updated,
            website: gameDetailEntities.website,
            playtime: gameDetailEntities.playtime,
            screenshotsCount: gameDetailEntities.screenshotsCount,
            moviesCount: gameDetailEntities.moviesCount,
            creatorsCount: gameDetailEntities.creatorsCount,
            achievementsCount: gameDetailEntities.achievementsCount,
            parentAchievementsCount: gameDetailEntities.parentAchievementsCount,
            developers: gameDetailEntities.developers.map { DeveloperMapper.mapDeveloperEntitiesToDomains(input: $0) },
            genres: gameDetailEntities.genres.map { DeveloperMapper.mapDeveloperEntitiesToDomains(input: $0) },
            tags: gameDetailEntities.tags.map { DeveloperMapper.mapDeveloperEntitiesToDomains(input: $0) },
            publishers: gameDetailEntities.publishers.map { DeveloperMapper.mapDeveloperEntitiesToDomains(input: $0) },
            esrbRating: gameDetailEntities.esrbRating != nil
                ? EsrbRatingMapper.mapEsrbRatingEntitiesToDomains(input: gameDetailEntities.esrbRating!)
                : nil,
            descriptionRaw: gameDetailEntities.descriptionRaw
        )
    }

    static func mapGameDetailResponseToDomainmapGameDetailResponseToDomain(
        id: Int,
        input gameDetailResponses: GameDetailResponse
    ) -> GameDetailModel {
        return GameDetailModel(
            id: id,
            welcomeDescription: gameDetailResponses.welcomeDescription,
            updated: gameDetailResponses.updated,
            website: gameDetailResponses.website,
            playtime: gameDetailResponses.playtime,
            screenshotsCount: gameDetailResponses.screenshotsCount,
            moviesCount: gameDetailResponses.moviesCount,
            creatorsCount: gameDetailResponses.creatorsCount,
            achievementsCount: gameDetailResponses.achievementsCount,
            parentAchievementsCount: gameDetailResponses.parentAchievementsCount,
            developers: gameDetailResponses.developers.map { DeveloperMapper.mapDeveloperResponsesToDomains(input: $0) },
            genres: gameDetailResponses.genres.map { DeveloperMapper.mapDeveloperResponsesToDomains(input: $0) },
            tags: gameDetailResponses.tags.map {
                DeveloperMapper.mapDeveloperResponsesToDomains(input: $0)
            },
            publishers: gameDetailResponses.publishers.map {
                DeveloperMapper.mapDeveloperResponsesToDomains(input: $0)
            },
            esrbRating: gameDetailResponses.esrbRating != nil
                ? EsrbRatingMapper.mapEsrbRatingResponsesToDomains(input: gameDetailResponses.esrbRating!)
                : nil,
            descriptionRaw: gameDetailResponses.descriptionRaw
        )
    }

}

final class DeveloperMapper {
    static func mapDeveloperEntitiesToDomains(
        input developerEntities: DeveloperEntity
    ) -> DeveloperModel {
        return DeveloperModel(
            id: developerEntities.id,
            name: developerEntities.name,
            slug: developerEntities.slug,
            gamesCount: developerEntities.gamesCount,
            imageBackground: developerEntities.imageBackground,
            domain: developerEntities.domain
        )
    }

    static func mapDeveloperResponsesToDomains(
        input developerResponses: DeveloperResponse
    ) -> DeveloperModel {
        return DeveloperModel(
            id: developerResponses.id,
            name: developerResponses.name,
            slug: developerResponses.slug,
            gamesCount: developerResponses.gamesCount,
            imageBackground: developerResponses.imageBackground,
            domain: developerResponses.domain
        )
    }
}

final class EsrbRatingMapper {
    static func mapEsrbRatingEntitiesToDomains(
        input esrbRatingEntities: EsrbRatingEntity
    ) -> EsrbRatingModel {
        return EsrbRatingModel(
            id: esrbRatingEntities.id,
            name: esrbRatingEntities.name,
            slug: esrbRatingEntities.slug
        )
    }

    static func mapEsrbRatingResponsesToDomains(
        input esrbRatingResponses: EsrbRatingResponse
    ) -> EsrbRatingModel {
        return EsrbRatingModel(
            id: esrbRatingResponses.id,
            name: esrbRatingResponses.name,
            slug: esrbRatingResponses.slug
        )
    }
}
