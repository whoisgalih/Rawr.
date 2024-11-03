//
//  HomeRouter.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import SwiftUI

class HomeRouter {

    func makeDetailView(for game: GameModel) -> some View {
        let detailUseCase = Injection.init().provideDetail(game: game)
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        return DetailView(presenter: presenter)
    }

}
