//
//  GameDetailEntity.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import Foundation
import RealmSwift

// MARK: - Welcome
class GameDetailEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var welcomeDescription = ""
    @objc dynamic var updated = ""
    @objc dynamic var website: String = ""
    @objc dynamic var playtime = 0
    @objc dynamic var screenshotsCount = 0
    @objc dynamic var moviesCount = 0
    @objc dynamic var creatorsCount: Int = 0
    @objc dynamic var achievementsCount = 0
    @objc dynamic var parentAchievementsCount: Int = 0
    @objc dynamic var esrbRating: EsrbRatingEntity? = EsrbRatingEntity()
    @objc dynamic var descriptionRaw: String = ""

    var developers = List<DeveloperEntity>()
    var genres = List<DeveloperEntity>()
    var tags = List<DeveloperEntity>()
    var publishers = List<DeveloperEntity>()

    override static func primaryKey() -> String? {
      return "id"
    }
}

// MARK: - Developer
class DeveloperEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var gamesCount: Int = 0
    @objc dynamic var imageBackground: String = ""
    @objc dynamic var domain: String?
}

// MARK: - ParentPlatform
class EsrbRatingEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var slug = ""

    override static func primaryKey() -> String? {
      return "id"
    }
}
