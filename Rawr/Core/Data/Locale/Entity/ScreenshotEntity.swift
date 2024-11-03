//
//  ScreenshotModel.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import Foundation
import RealmSwift

// MARK: - Result
class ScreenshotEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var image: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var isDeleted: Bool = false

    override static func primaryKey() -> String? {
      return "id"
    }
}
