//
//  GamesResponse.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation

// MARK: - GameResponse
struct GamesResponse: Codable {
    let count: Int
    let next, previous: String?
    let results: [GameResponse]
    let gamesCount, reviewsCount, recommendationsCount: Int

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
        case gamesCount = "games_count"
        case reviewsCount = "reviews_count"
        case recommendationsCount = "recommendations_count"
    }
}

// MARK: - Result
struct GameResponse: Codable {
    let id: Int
    let slug, name, released: String
    let tba: Bool
    let backgroundImage: String?
    let rating: Double
    let reviewsTextCount, added: Int
    let metacritic: Int?
    let playtime, suggestionsCount: Int
    let updated: String
    let reviewsCount: Int
    let parentPlatforms: [ParentPlatform]
    let genres: [Genre]
    let tags: [Genre]
    let esrbRating: EsrbRating?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case reviewsTextCount = "reviews_text_count"
        case added
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case reviewsCount = "reviews_count"
        case parentPlatforms = "parent_platforms"
        case genres, tags
        case esrbRating = "esrb_rating"
    }
}
