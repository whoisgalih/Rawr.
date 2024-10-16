//
//  GameDetailPage.swift
//  Rawr
//
//  Created by Galih Akbar on 30/09/22.
//

import SwiftUI

struct GameDetailPage: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.managedObjectContext) private var viewContext

    let network: NetworkService = NetworkService()

    let game: Game
    let imageData: Data?

    @State private var gameDetail: GameDetail?
    @State private var screenshots: [Screenshot]?
    @State private var downloadState: DownloadState = .new
    @State private var isShowingFullDescription: Bool = false
    @State private var isFavorite: Bool = false

    private enum CoordinateSpaces {
        case scrollView
    }

    init(_ game: Game, imageData: Data? = nil) {
        self.game = game
        self.imageData = imageData
    }

    func mapMultipleStringWithComa(_ stringsParams: [String]) -> String {
        var strings: [String] = stringsParams

        if strings.isEmpty {
            return ""
        }

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

    var body: some View {
        ScrollView {
            ParallaxHeader(
                coordinateSpace: CoordinateSpaces.scrollView,
                defaultHeight: 300
            ) {
                if downloadState == .new {
                    ProgressView()
                }

                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    // Load the image from Core Data if available
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else if game.backgroundImage != "", let url = URL(string: game.backgroundImage) {
                    // Load the image from URL if available
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    // Fallback placeholder image
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                }

                if downloadState == .failed && imageData == nil {
                    Text("failed")
                }
            }

            VStack(spacing: 20) {
                VStack(alignment: .center, spacing: 0) {
                    Text("\(game.name)")
                        .customFont(.largeTitle, .bold)
                        .multilineTextAlignment(.center)
                    if gameDetail != nil, let developers = gameDetail?.developers, developers.count > 0 {
                        Text("\(mapMultipleStringWithComa(developers.map { $0.name }))")
                            .customFont(.title3)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)

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
                            PlatformIcons(platforms: game.platforms.map { $0.platform.slug })
                            Spacer()
                            RatingView(game.rating)
                        }
                    }
                }
                .padding(.horizontal, 16)

                if gameDetail == nil {
                    HStack {
                        InformationDescription(title: "Release Date", description: game.released)
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    NetworkView()
                }

                if downloadState == .downloaded && gameDetail != nil {
                    if let age = gameDetail?.esrbRating?.name {
                        HStack(spacing: 10) {
                            Text("Age Rating:")
                                .customFont(.caption, .bold)
                            Tag("\(age)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Genre:")
                            .customFont(.caption, .bold)
                            .padding(.horizontal, 16)
                        if let genres =  gameDetail?.genres {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(genres) { genre in
                                        Tag("\(genre.name)")
                                    }
                                }
                                .padding(.horizontal, 16)
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
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                isShowingFullDescription.toggle()
                            }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Screenshots")
                            .customFont(.headline)
                            .padding(.horizontal, 16)
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
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Information")
                            .customFont(.headline)
                        if let gameDetail: GameDetail = gameDetail {
                            if let url: URL = URL(string: "\(gameDetail.website)") {
                                HStack {
                                    Text("Website")
                                        .customFont(.subheadline, .bold)
                                    Spacer()
                                    Image(systemName: "safari")
                                }
                                .onTapGesture {
                                    openURL(url)
                                }
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
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color.white)
        }
        .task {
            await network.getGameDetail(gameID: game.id, gameDetail: $gameDetail, downloadState: $downloadState)
            await network.getScreenshot(gameID: game.id, screenshots: $screenshots, downloadState: $downloadState)
        }
        .navigationTitle("\(game.name)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        if isFavorite {
                            FavoriteManager.removeGameFromFavorites(game: game, context: viewContext)
                        } else {
                            FavoriteManager.saveGameToFavorites(game: game, context: viewContext)
                        }
                        isFavorite.toggle()
                    },
                    label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .frame(width: 30)
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                )
            }
        }
        .onAppear {
            isFavorite = FavoriteManager.isGameFavorite(game: game, context: viewContext)
        }
    }
}

struct GameDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        GameDetailPage(exampleGame)
            .environment(\.managedObjectContext, context)
    }
}
