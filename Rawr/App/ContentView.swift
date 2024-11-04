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
    @EnvironmentObject var searchPresenter: SearchPresenter

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

            // MARK: - Search Tab
            NavigationView {
                SearchView(presenter: searchPresenter)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
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
                Image(systemName: "person.fill")
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
        let searchUseCase: SearchUseCase = Injection.init(true).provideSearch()
        let searchPresenter: SearchPresenter = SearchPresenter(searchUseCase: searchUseCase)
        ContentView()
            .environmentObject(homePresenter)
            .environmentObject(favoritePresenter)
            .environmentObject(searchPresenter)
    }
}
