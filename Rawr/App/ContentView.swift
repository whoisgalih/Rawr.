//
//  ContentView.swift
//  Rawr
//
//  Created by Galih Akbar on 18/09/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var homePresenter: HomePresenter
    @EnvironmentObject var favoritePresenter: FavoritePresenter

    var body: some View {
        TabView {
            // MARK: - Home Tab
            NavigationView {
                HomeView(presenter: homePresenter)
            }
            .tabItem {
                Image(systemName: "gamecontroller")
                Text("Games")
            }

            // MARK: - Favorites Tab
            NavigationView {
                FavoriteView(presenter: favoritePresenter)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }

            // MARK: - Profile Tab
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("Profile")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let homeUseCase: HomeUseCase = Injection.init(true).provideHome()
        let homePresenter: HomePresenter = HomePresenter(homeUseCase: homeUseCase)
        let favoriteUseCase: FavoriteUseCase = Injection.init(true).provideFavorite()
        let favoritePresenter: FavoritePresenter = FavoritePresenter(favoriteUseCase: favoriteUseCase)
        ContentView()
            .environmentObject(homePresenter)
            .environmentObject(favoritePresenter)
    }
}
