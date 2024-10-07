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

    private enum CoordinateSpaces {
        case scrollView
    }
    
    init(_ game: Game) {
        self.game = game
    }
    
    func mapDevelopersName(_ developers: [Developer]) -> String {
        var developersString: [String] = developers.map { $0.name }
        
        if developers.count <= 1 {
            return developersString[0]
        } else {
            let lastDev: String = developersString.removeLast()
            var stringResult: String = developersString.removeFirst()
            
            for devName in developersString {
                stringResult += ", \(devName)"
            }
            
            stringResult += ", and \(lastDev)"
            
            return lastDev
        }
        
    }
    
    func getGame(_ gameID: Int) async {
        let network = NetworkService()
        do {
            gameDetail = try await network.getGameDetail(gameID: game.id)
            downloadState = .downloaded
        } catch {
            print(error)
            downloadState = .failed
        }
    }
    
    func getScennshots(_ gameID: Int) async {
        let network = NetworkService()
        do {
            screenshots = try await network.getScreenshot(gameID: game.id)
            downloadState = .downloaded
        } catch {
            print(error)
            downloadState = .failed
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

                AsyncImage(url: URL(string: "\(game.backgroundImage)")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                
                if downloadState == .failed {
                    Text("failed")
                }
            }
            
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(game.name)")
                            .customFont(.largeTitle, .bold)
                            .multilineTextAlignment(.center)
                        if let developers = gameDetail?.developers, developers.count > 0 {
                            Text("\(mapDevelopersName(developers))")
                                .customFont(.title3)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                
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
                                PlatformIcons(platforms: game.parentPlatforms)
                            }
                            Spacer()
                            RatingView(game.rating)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
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
                    //                    Divider()
                    //                        .frame(height: 2)
                    //                        .overlay(Color(hex: "EAEAEA"))
                    if let _gameDetail: GameDetail = gameDetail {
                        HStack {
                            Text("Website")
                                .customFont(.subheadline, .bold)
                            Spacer()
                            Image(systemName: "safari")
                        }
                        .onTapGesture {
                            openURL(URL(string: "\(_gameDetail.website)")!)
                        }
                        InformationDescription(title: "Platform", description: "PlayStation 4, Xbox One, Xbox Series S/X, PlayStation 5, PC")
                        InformationDescription(title: "Platform", description: "PlayStation 4, Xbox One, Xbox Series S/X, PlayStation 5, PC")
                        InformationDescription(title: "Platform", description: "PlayStation 4, Xbox One, Xbox Series S/X, PlayStation 5, PC")
                        InformationDescription(title: "Platform", description: "PlayStation 4, Xbox One, Xbox Series S/X, PlayStation 5, PC")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                .padding(.horizontal, 16)
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.white)
        }
        .task {
            await getGame(game.id)
            await getScennshots(game.id)
        }
        .navigationTitle("\(game.name)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GameDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailPage(exampleGame)
    }
}
