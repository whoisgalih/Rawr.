//
//  RawrApp.swift
//  Rawr
//
//  Created by Galih Akbar on 18/09/22.
//

import SwiftUI

@main
struct RawrApp: App {
    // Injecting dependencies into presenters for modules.
    let homePresenter = HomePresenter(homeUseCase: Injection.init().provideHome())
    let favoritePresenter: FavoritePresenter = FavoritePresenter(favoriteUseCase: Injection.init().provideFavorite())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homePresenter)
                .environmentObject(favoritePresenter)
                .environmentObject(UserModel())
        }
    }
}
