//
//  ContentView.swift
//  Rawr
//
//  Created by Galih Akbar on 18/09/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var homePresenter: HomePresenter
//    @EnvironmentObject var favoritePresenter: FavoritePresenter
//    @EnvironmentObject var profilePresenter: ProfilePresenter

    var body: some View {
        TabView {
            // Home Tab
            NavigationView {
                HomeView(presenter: homePresenter)
            }
            .tabItem {
                Image(systemName: "gamecontroller")
                Text("Games")
            }

//            // Favorites Tab
//            NavigationView {
//                FavoritesView(presenter: favoritePresenter)
//            }
//            .tabItem {
//                Image(systemName: "heart.fill")
//                Text("Favorites")
//            }
//
//            // Profile Tab
//            NavigationView {
//                ProfileView(presenter: profilePresenter)
//            }
//            .tabItem {
//                Image(systemName: "person.circle")
//                Text("Profile")
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(UserModel())
    }
}
