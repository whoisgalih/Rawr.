//
//  DetailPresenter.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import SwiftUI
import Combine

class DetailPresenter: ObservableObject {

    private var cancellables: Set<AnyCancellable> = []
    private let detailUseCase: DetailUseCase

    @Published var game: GameModel
    @Published var gameDetail: GameDetailModel?
    @Published var screenshots: [ScreenshotModel] = []
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false

    init(detailUseCase: DetailUseCase) {
        self.detailUseCase = detailUseCase
        game = detailUseCase.getGame()
    }

    func getGameDetail() {
      isLoading = true
      detailUseCase.getGameDetail()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.isError = true
            self.isLoading = false
          case .finished:
            self.isLoading = false
          }
        }, receiveValue: { gameDetail in
          self.gameDetail = gameDetail
        })
        .store(in: &cancellables)
    }

    func getScreenshots() {
      isLoading = true
        detailUseCase.getScreenshots()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.isError = true
            self.isLoading = false
          case .finished:
            self.isLoading = false
          }
        }, receiveValue: { screenshots in
          self.screenshots = screenshots
        })
        .store(in: &cancellables)
    }

    func updateFavoriteGame() {
        detailUseCase.updateFavoriteGame()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure:
              self.errorMessage = String(describing: completion)
            case .finished:
              self.isLoading = false
            }
          }, receiveValue: { game in
            self.game = game
          })
          .store(in: &cancellables)
    }
}
