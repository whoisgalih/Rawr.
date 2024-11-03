//
//  RemoteDataSource.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {

    func getGames() -> AnyPublisher<[GameResponse], Error>

}

final class RemoteDataSource: NSObject {

    private override init() { }

    static let sharedInstance: RemoteDataSource =  RemoteDataSource()

    private var apiKey: String {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }

}

extension RemoteDataSource: RemoteDataSourceProtocol {

    func getGames() -> AnyPublisher<[GameResponse], Error> {
        return Future<[GameResponse], Error> { completion in
            if let url = URL(string: Endpoints.Gets.list.url) {
                let parameters: [String: String] = [
                    "key": self.apiKey,
                    "ordering": "-relevance",
                    "discover": "true",
                    "page": "1"
                ]

                AF.request(url, parameters: parameters)
                    .validate()
                    .responseDecodable(of: GamesResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.results))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }

}
