//
//  NetworkService.swift
//  Rawr
//
//  Created by Galih Akbar on 04/10/22.
//

import SwiftUI

enum DownloadState {
    case new, downloaded, failed
}

class NetworkService {
    // MARK: Gunakan API Key dalam akun Anda.
    private var apiKey: String {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }

    struct ResponseDetail: Codable {
        let detail: String
    }

    func getScreenshot(gameID: Int, screenshots: Binding<[Screenshot]?>, downloadState: Binding<DownloadState>) async {
        var components = URLComponents(string: "https://api.rawg.io/api/games/\(gameID)/screenshots")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]

        let request = URLRequest(url: components.url!)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error: Can't fetching data.")
            }

            let decoder = JSONDecoder()
            let result = try decoder.decode(ScreenshotResponse.self, from: data)

            screenshots.wrappedValue = result.results
            downloadState.wrappedValue = .downloaded
        } catch {
            downloadState.wrappedValue = .failed
        }
    }

    func getGameDetail(gameID: Int, gameDetail: Binding<GameDetail?>, downloadState: Binding<DownloadState>) async {
        var components = URLComponents(string: "https://api.rawg.io/api/games/\(gameID)")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error: Can't fetching data.")
            }

            let decoder = JSONDecoder()
            let result = try decoder.decode(GameDetail.self, from: data)

            gameDetail.wrappedValue = result
            downloadState.wrappedValue = .downloaded
        } catch {
            downloadState.wrappedValue = .failed
        }
    }

    func getTrendingGames(_ page: Int) async throws -> ([Game], isNextalbe: Bool) {
        var components = URLComponents(string: "https://api.rawg.io/api/games/lists/main")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "ordering", value: "-relevance"),
            URLQueryItem(name: "dicover", value: "true"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let request = URLRequest(url: components.url!)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GamesResponse.self, from: data)

        if result.next != nil {
            return (gamesMapper(input: result.results), true)
        } else {
            return (gamesMapper(input: result.results), false)
        }
    }

}

extension NetworkService {
    fileprivate func gamesMapper(
        input gameResponse: [GamesResult]
    ) -> [Game] {
        return gameResponse.map { result in
            return Game(
                id: result.id,
                slug: result.slug,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage ?? "",
                rating: result.rating,
                parentPlatforms: result.parentPlatforms
            )
        }
    }
}
