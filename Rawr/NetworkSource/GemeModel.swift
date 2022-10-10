//
//  GemeModel.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/22.
//

import Foundation

// MARK: - Welcome
struct GameDetail: Codable {
    let welcomeDescription, updated, website: String
    let playtime, screenshotsCount, moviesCount, creatorsCount: Int
    let achievementsCount, parentAchievementsCount: Int
    let developers, genres, tags, publishers: [Developer]
    let esrbRating: EsrbRating?
    let descriptionRaw: String

    enum CodingKeys: String, CodingKey {
        case welcomeDescription = "description"
        case updated
        case website
        case playtime
        case screenshotsCount = "screenshots_count"
        case moviesCount = "movies_count"
        case creatorsCount = "creators_count"
        case achievementsCount = "achievements_count"
        case parentAchievementsCount = "parent_achievements_count"
        case developers, genres, tags, publishers
        case esrbRating = "esrb_rating"
        case descriptionRaw = "description_raw"
    }
}

// MARK: - Developer
struct Developer: Codable, Identifiable {
    let id: Int
    let name, slug: String
    let gamesCount: Int
    let imageBackground: String
    let domain: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain
    }
}
