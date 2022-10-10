//
//  GameDetailPage.swift
//  Rawr
//
//  Created by Galih Akbar on 30/09/22.
//

import SwiftUI

struct GameDetailPage: View {
    @Environment(\.openURL) private var openURL

    let game: Game
    @State private var gameDetail: GameDetail?
    @State private var screenshots: [Screenshot]?
    @State private var downloadState: DownloadState = .new
    @State private var isShowingFullDescription: Bool = false

    init(_ game: Game) {
        self.game = game
    }

    func mapMultipleStringWithComa(_ stringsParams: [String]) -> String {
        var strings: [String] = stringsParams

        if strings.count <= 1 {
            return strings[0]
        } else {
            let lastStr: String = strings.removeLast()
            var stringResult: String = strings.removeFirst()

            for str in strings {
                stringResult += ", \(str)"
            }

            stringResult += ", and \(lastStr)"

            return stringResult
        }
    }

    func getGame(_ gameID: Int) async {
        let network = NetworkService()
        do {
            gameDetail = try await network.getGameDetail(gameID: game.id)
            downloadState = .downloaded
        } catch {
            downloadState = .failed
        }
    }

    func getScennshots(_ gameID: Int) async {
        let network = NetworkService()
        do {
            screenshots = try await network.getScreenshot(gameID: game.id)
            downloadState = .downloaded
        } catch {
            downloadState = .failed
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    if downloadState == .new {
                        ProgressView()
                    }

                    GeometryReader { geometry in
                        AsyncImage(url: URL(string: "\(game.backgroundImage)")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(
                            width: geometry.size.width,
                            height: geometry.frame(in: .global).minY + 404 >= 0 ?
                                geometry.frame(in: .global).minY + 404 : 0
                        )
                        .clipped()
                        .padding(.top, -1 * geometry.frame(in: .global).minY)
                        .background(Color.regularGray)
                    }
                    if downloadState == .failed {
                        Text("failed")
                    }
                }
                .frame(height: 404)
                .background(Color.regularGray)

                VStack(alignment: .center, spacing: 0) {
                    Text("\(game.name)")
                        .customFont(.largeTitle, .bold)
                        .multilineTextAlignment(.center)
                    if let developers = gameDetail?.developers, developers.count > 0 {
                        Text("\(mapMultipleStringWithComa(developers.map { $0.name }))")
                            .customFont(.title3)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 35)

                VStack(spacing: 8) {
                    HStack {
                        Text("Platform")
                            .customFont(.caption, .bold)
                        Spacer()
                        Text("Rating")
                            .customFont(.caption, .bold)
                    }
                    HStack {
                        HStack {
                            if downloadState == .downloaded {
                                PlatformIcons(platforms: game.platforms.map { $0.platform.slug })
                            }
                            Spacer()
                            RatingView(game.rating)
                        }
                    }
                }
                .padding(.horizontal, 35)

                if let age = gameDetail?.esrbRating?.name {
                    HStack(spacing: 10) {
                        Text("Age Rating:")
                            .customFont(.caption, .bold)
                        Tag("\(age)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 35)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Genre:")
                        .customFont(.caption, .bold)
                        .padding(.horizontal, 35)
                    if let genres =  gameDetail?.genres {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(genres) { genre in
                                    Tag("\(genre.name)")
                                }
                            }
                            .padding(.horizontal, 35)
                            .padding(.vertical, 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let description = gameDetail?.descriptionRaw {
                    Text("\(description)")
                        .lineLimit(isShowingFullDescription ? .max : 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .customFont(.body)
                        .padding(.horizontal, 35)
                        .onTapGesture {
                            isShowingFullDescription.toggle()
                        }
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Screenshots")
                        .customFont(.headline)
                        .padding(.horizontal, 35)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(screenshots ?? []) { screenshot in
                                VStack {
                                    AsyncImage(url: URL(string: "\(screenshot.image)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .frame(width: 225, height: 125, alignment: .center)
                                .background(Color.regularGray)
                                .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 35)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Information")
                        .customFont(.headline)
                    if let gameDetail: GameDetail = gameDetail {
                        HStack {
                            Text("Website")
                                .customFont(.subheadline, .bold)
                            Spacer()
                            Image(systemName: "safari")
                        }
                        .onTapGesture {
                            openURL(URL(string: "\(gameDetail.website)")!)
                        }
                        InformationDescription(
                            title: "Platform",
                            description: "\(mapMultipleStringWithComa(game.platforms.map { $0.platform.name }))"
                        )
                        InformationDescription(
                            title: "Genre",
                            description: "\(mapMultipleStringWithComa(gameDetail.genres.map { $0.name }))"
                        )
                        InformationDescription(
                            title: "Release Date",
                            description: "\(game.released)"
                        )
                        InformationDescription(
                            title: "Publisher",
                            description: "\(mapMultipleStringWithComa(gameDetail.publishers.map { $0.name }))"
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 35)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .task {
            await getGame(game.id)
            await getScennshots(game.id)
        }
        .navigationTitle("\(game.name)")
    }
}

struct GameDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailPage(exampleGame)
    }
}
