//
//  ScreenshotsModel.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/22.
//

// MARK: - Welcome
struct ScreenshotResponse: Codable {
    let count: Int
    let results: [Screenshot]
}

// MARK: - Result
struct Screenshot: Codable, Identifiable {
    let id: Int
    let image: String
    let width, height: Int
    let isDeleted: Bool

    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}
