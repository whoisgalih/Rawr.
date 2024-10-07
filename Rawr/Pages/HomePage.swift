//
//  HomePage.swift
//  Rawr
//
//  Created by Galih Akbar on 26/09/22.
//

import SwiftUI

struct HomePage: View {
    @State var seacrhInput: String = ""
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                // MARK: Search Bar
                TextField("Search games", text: $seacrhInput)
                    .customFont(.caption)
                    .textFieldStyle(SearchTextFiledStyle())
                    .overlay(alignment: .leading) {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, 27)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 16)
                
                // MARK: Categories
                Text("Categories")
                    .padding(.top, 6)
                    .padding(.horizontal, 16)
                    .customFont(.title3)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        Category(name: "Action", icon: Image("sword"), active: true)
                        Category(name: "Strategy", icon: Image("chess"), active: false)
                        Category(name: "RPG", icon: Image("user"), active: false)
                        Category(name: "Shooter", icon: Image("tank"), active: false)
                        Category(name: "Strategy", icon: Image("chess"), active: false)
                        Category(name: "Adventure", icon: Image("map"), active: false)
                        Category(name: "Puzzle", icon: Image("puzzle"), active: false)
                        Category(name: "Racing", icon: Image("helmet"), active: false)
                        Category(name: "Sports", icon: Image("basketball"), active: false)
                    }
                    .padding(.horizontal, 16)
                }
                
                // MARK: Trending Games
                HStack(alignment: .center) {
                    Text("Trending Games")
                        .customFont(.title3)
                    Spacer()
                    Text("See all")
                        .customFont(.caption)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 6)
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        TrendingGame(platforms: ["windows", "mac"], gameTitle: "Game Title", gameImage: Image(systemName: "photo"))
                        
                        TrendingGame(platforms: ["windows", "mac"], gameTitle: "Game Title", gameImage: Image(systemName: "photo"))
                    }
                    .padding(.horizontal, 16)
                }
                
                // MARK: Games of The Year
                HStack(alignment: .center) {
                    Text("New Games")
                        .customFont(.title3)
                    Spacer()
                    Text("See all")
                        .customFont(.caption)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 6)
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        NewGame()
                    }
                    .padding(.horizontal, 16)
                }
                
                // MARK: Games of The Year
                HStack(alignment: .center) {
                    Text("Games of The Year")
                        .customFont(.title3)
                    Spacer()
                    Text("See all")
                        .customFont(.caption)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 6)
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        GameOfTheYear()
                        GameOfTheYear()
                    }
                    .padding(.horizontal, 16)
                }
                
                // MARK: Show All Games
                ZStack(alignment: .bottomTrailing) {
                    Image("controller")
                    VStack(alignment: .leading) {
                        Text("Show All Games")
                            .customFont(.title3, .bold)
                            .frame(width: 100)
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }
                    .frame(maxWidth: .infinity, minHeight: 148, alignment: .topLeading)
                    .padding(28)
                }
                .background(Color.regularGray)
                .cornerRadius(28)
                .padding(.horizontal, 16)
                
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
