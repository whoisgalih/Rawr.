//
//  GamesListPage.swift
//  Rawr
//
//  Created by Galih Akbar on 30/09/22.
//

import SwiftUI

struct GamesListPage: View {
    @State private var games: [Game] = []
    @State private var isNextable: Bool = true
    @State private var lastID: Int = 0
    @State private var page: Int = 1
    @State private var downloadState: DownloadState = .new
    @State private var displayNavTitle: Bool = false
    
    init() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [.font : UIFont(name: "Poppins Medium", size: 18)!]
    }
    
    func appendGame(_ page: Int) async {
        var gameInPage: [Game] = []
        print(self.page)
        let network = NetworkService()
        do {
            (gameInPage, isNextable) = try await network.getTrendingGames(page)
            games.append(contentsOf: gameInPage)
            lastID = gameInPage[gameInPage.count - 1].id
            downloadState = .downloaded
        } catch {
            print(error)
            downloadState = .failed
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
//                    GeometryReader { geo -> Text in
//                        withAnimation(.easeInOut(duration: 100)) {
//                            displayNavTitle = geo.frame(in: .global).minY < 20
//                        }
//                        return Text("")
//                    }
                    
//                    Text("Games")
//                        .customFont(.largeTitle, .bold)
//                        .padding(.top, 45)
                    
                    
                    
                    if downloadState == .downloaded {
                        ForEach(games) { game in
                            NavigationLink(destination: GameDetailPage(game)) {
                                GameListRow(game: game)
                                    .onAppear {
                                        if isNextable && lastID == game.id {
                                            Task {
                                                self.page += 1
                                                await appendGame(page)
                                            }
                                        }
                                    }
                            }
                            .foregroundColor(.textPrimary)
                        }
                    } else if downloadState == .new {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 300)
                    }
                    
                    if isNextable {
                        if downloadState == .failed {
                            Text("Failed to get data")
                                .frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
                                .customFont(.caption)
                        } else if downloadState != .new {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 100)
                        }
                    } else if !isNextable && downloadState == .downloaded {
                        Text("End of data")
                            .frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
                            .customFont(.caption)
                    }
                }
                .padding(.horizontal, 16)
                .task {
                    if downloadState == .new {
                        await appendGame(page)
                    }
                }
            }
            .navigationTitle("Games")
        }
        .accentColor(.textPrimary)
    }
}

struct GamesListPage_Previews: PreviewProvider {
    static var previews: some View {
        GamesListPage()
    }
}
