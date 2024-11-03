//
//  ScreenshotResponse.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//


// MARK: - Result
struct ScreenshotModel: Codable, Identifiable {
    let id: Int
    let image: String
    let width, height: Int
    let isDeleted: Bool
}
