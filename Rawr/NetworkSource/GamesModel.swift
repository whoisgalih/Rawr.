//
//  GamesModel.swift
//  Rawr
//
//  Created by Galih Akbar on 04/10/22.
//

import Foundation

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
    let ratingTop: Int
    let ratings: [Rating]
    let ratingsCount, reviewsTextCount, added: Int
    let metacritic: Int?
    let playtime, suggestionsCount: Int
    let updated: String
    let reviewsCount: Int
    let parentPlatforms: [ParentPlatform]
    let genres: [Genre]
    let stores: [Store]
    let tags: [Genre]
    let esrbRating: EsrbRating?
    let shortScreenshots: [ShortScreenshot]

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case reviewsCount = "reviews_count"
        case parentPlatforms = "parent_platforms"
        case genres, stores, tags
        case esrbRating = "esrb_rating"
        case shortScreenshots = "short_screenshots"
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

// MARK: - PlatformElement
struct PlatformElement: Codable {
    let platform: PlatformPlatform
    let releasedAt: String?
    let requirementsEn, requirementsRu: Requirements?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirementsEn = "requirements_en"
        case requirementsRu = "requirements_ru"
    }
}

// MARK: - PlatformPlatform
struct PlatformPlatform: Codable {
    let id: Int
    let name: Name
    let slug: Slug
    let yearStart: Int?
    let gamesCount: Int
    let imageBackground: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case yearStart = "year_start"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

enum Name: String, Codable {
    case linux = "Linux"
    case macOS = "macOS"
    case nintendoSwitch = "Nintendo Switch"
    case pc = "PC"
    case playStation4 = "PlayStation 4"
    case playStation5 = "PlayStation 5"
    case web = "Web"
    case xboxOne = "Xbox One"
    case xboxSeriesSX = "Xbox Series S/X"
}

enum Slug: String, Codable {
    case linux = "linux"
    case macos = "macos"
    case nintendoSwitch = "nintendo-switch"
    case pc = "pc"
    case playstation4 = "playstation4"
    case playstation5 = "playstation5"
    case web = "web"
    case xboxOne = "xbox-one"
    case xboxSeriesX = "xbox-series-x"
}

// MARK: - Requirements
struct Requirements: Codable {
    let minimum: String
    let recommended: String?
}

// MARK: - Rating
struct Rating: Codable {
    let id: Int
    let title: Title
    let count: Int
    let percent: Double
}

enum Title: String, Codable {
    case exceptional = "exceptional"
    case meh = "meh"
    case recommended = "recommended"
    case skip = "skip"
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Codable {
    let id: Int
    let image: String
}

// MARK: - Store
struct Store: Codable {
    let id: Int
    let store: Genre
}

struct Game: Identifiable {
    let id: Int
    let slug, name, released: String
    let backgroundImage: String
    let rating: Double
    let parentPlatforms: [String]
    
    init(id: Int, slug: String, name: String, released: String, backgroundImage: String, rating: Double, parentPlatforms: [ParentPlatform]) {
        self.id = id
        self.slug = slug
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.parentPlatforms = parentPlatforms.map { platform in
            return platform.platform.slug
        }
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
