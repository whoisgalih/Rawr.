//
//  GameModel.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import RealmSwift

// MARK: - Game Model
struct GameModel: Equatable, Identifiable {
    let id: Int
    let slug, name, released: String
    let backgroundImage: String
    let rating: Double
}

let exampleGameModel: GameModel = GameModel(
    id: 326292,
    slug: "fall-guys",
    name: "Fall Guys",
    released: "2022-12-31",
    backgroundImage: "https://media.rawg.io/media/games/5eb/5eb49eb2fa0738fdb5bacea557b1bc57.jpg",
    rating: 3.76
//    parentPlatforms: [
//        ParentPlatform(platform: EsrbRating(id: 1, name: "PC", slug: "pc")),
//        ParentPlatform(platform: EsrbRating(id: 2, name: "PlayStation", slug: "playstation")),
//        ParentPlatform(platform: EsrbRating(id: 3, name: "Xbox", slug: "xbox")),
//        ParentPlatform(platform: EsrbRating(id: 7, name: "Nintendo", slug: "nintendo"))
//    ]
)
