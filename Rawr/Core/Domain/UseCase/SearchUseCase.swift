//
//  SearchUseCase.swift
//  Rawr
//
//  Created by Galih Akbar on 04/11/24.
//

import Foundation
import Combine

protocol SearchUseCase {

  func searchGame(by title: String) -> AnyPublisher<[GameModel], Error>

}

class SearchInteractor: SearchUseCase {

  private let repository: GameRepositoryProtocol

  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }

  func searchGame(by title: String) -> AnyPublisher<[GameModel], Error> {
    return repository.searchGame(by: title)
  }

}
