//
//  ScreenshotResponse.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

// MARK: - Welcome
struct ScreenshotsResponse: Codable {
    let count: Int
    let results: [ScreenshotResponse]
}

// MARK: - Result
struct ScreenshotResponse: Codable, Identifiable {
    let id: Int
    let image: String
    let width, height: Int
    let isDeleted: Bool

    enum CodingKeys: String, CodingKey {
        case id, image, width, height
        case isDeleted = "is_deleted"
    }
}
