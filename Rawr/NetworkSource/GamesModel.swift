//
//  GamesModel.swift
//  Rawr
//
//  Created by Galih Akbar on 04/10/22.
//

import CoreData

// MARK: - GameResponse
struct GamesResponse: Codable {
    let count: Int
    let next, previous: String?
    let results: [GamesResult]
    let gamesCount, reviewsCount, recommendationsCount: Int

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
        case gamesCount = "games_count"
        case reviewsCount = "reviews_count"
        case recommendationsCount = "recommendations_count"
    }
}

// MARK: - Result
struct GamesResult: Codable {
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

// MARK: - EsrbRating
struct EsrbRating: Codable {
    let id: Int
    let name, slug: String
}

// MARK: - Genre
struct Genre: Codable {
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

// MARK: - ParentPlatform
struct ParentPlatform: Codable {
    let platform: EsrbRating
}

// MARK: - Game Model
struct Game: Identifiable {
    let id: Int
    let slug, name, released: String
    let backgroundImage: String
    let rating: Double
    let platforms: [ParentPlatform]

    init(
        id: Int,
        slug: String,
        name: String,
        released: String,
        backgroundImage: String,
        rating: Double,
        parentPlatforms: [ParentPlatform]
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.platforms = parentPlatforms
    }
}

let exampleGame: Game = Game(
    id: 326292,
    slug: "fall-guys",
    name: "Fall Guys",
    released: "2022-12-31",
    backgroundImage: "https://media.rawg.io/media/games/5eb/5eb49eb2fa0738fdb5bacea557b1bc57.jpg",
    rating: 3.76,
    parentPlatforms: [
        ParentPlatform(platform: EsrbRating(id: 1, name: "PC", slug: "pc")),
        ParentPlatform(platform: EsrbRating(id: 2, name: "PlayStation", slug: "playstation")),
        ParentPlatform(platform: EsrbRating(id: 3, name: "Xbox", slug: "xbox")),
        ParentPlatform(platform: EsrbRating(id: 7, name: "Nintendo", slug: "nintendo"))
    ]
)
