//
//  GameEntity.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import RealmSwift

class GameEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var slug = ""
    @objc dynamic var name = ""
    @objc dynamic var released = ""
    @objc dynamic var backgroundImage = ""
    @objc dynamic var rating: Double = 0.0

    var platforms = List<ParentPlatformEntity>()

    override static func primaryKey() -> String? {
      return "id"
    }
}

// MARK: - ParentPlatform
class ParentPlatformEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var slug = ""

    override static func primaryKey() -> String? {
      return "id"
    }
}
