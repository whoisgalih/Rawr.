//
//  SearchRouter.swift
//  Rawr
//
//  Created by Galih Akbar on 04/11/24.
//

import SwiftUI

class SearchRouter {

    func makeDetailView(for game: GameModel) -> some View {
        let detailUseCase = Injection.init().provideDetail(game: game)
        let presenter = DetailPresenter(detailUseCase: detailUseCase)
        return DetailView(presenter: presenter)
    }

}
