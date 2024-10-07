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
    @State private var displayNavTitle: Bool = false
    
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
            VStack(spacing: 20) {
                ZStack {
                    if downloadState == .new {
                        ProgressView()
                    }
                    GeometryReader { geo -> Text in
                        withAnimation(.easeInOut(duration: 100)) {
                            displayNavTitle = geo.frame(in: .global).minY < 20
                        }
                        return Text("")
                    }

                    GeometryReader { geometry in
                        AsyncImage(url: URL(string: "\(game.backgroundImage)")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: geometry.size.width, height: geometry.frame(in: .global).minY + 404)
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
                                PlatformIcons(platforms: game.parentPlatforms)
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
