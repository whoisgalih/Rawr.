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

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
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
    let parentPlatforms: [ParentPlatformResponse]
    let genres: [GenreResponse]
    let tags: [GenreResponse]
    let esrbRating: EsrbRatingResponse?

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

// MARK: - ParentPlatform
struct ParentPlatformResponse: Codable {
    let platform: EsrbRatingResponse
}

// MARK: - Genre
struct GenreResponse: Codable {
    let id: Int
    let name, slug: String
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain
    }
}
