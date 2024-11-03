//
//  FavoriteRouter.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import SwiftUI

class FavoriteRouter {

    func makeGameView(for game: GameModel) -> some View {
        let detailUseCase = Injection.init().provideDetail(game: game)
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        return DetailView(presenter: presenter)
    }

}
