//
//  TabView.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//

import SwiftUI

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            // Explore Page (GamesListPage)
            GamesListPage()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Explore")
                }

            // Favorites Page
            FavoritesPage()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }

            // Profile Page
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .environment(\.managedObjectContext, viewContext) // Make the context available to all pages
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
