//
//  GameDetailModel.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import Foundation

// MARK: - Welcome
struct GameDetailModel: Codable {
    let id: Int
    let welcomeDescription, updated, website: String
    let playtime, screenshotsCount, moviesCount, creatorsCount: Int
    let achievementsCount, parentAchievementsCount: Int
    let developers, genres, tags, publishers: [DeveloperModel]
    let esrbRating: EsrbRatingModel?
    let descriptionRaw: String
}

// MARK: - Developer
struct DeveloperModel: Codable, Identifiable {
    let id: Int
    let name, slug: String
    let gamesCount: Int
    let imageBackground: String
    let domain: String?
}

// MARK: - EsrbRating
struct EsrbRatingModel: Codable, Identifiable {
    let id: Int
    let name, slug: String
}
