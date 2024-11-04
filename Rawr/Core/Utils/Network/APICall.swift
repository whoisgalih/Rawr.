//
//  APICall.swift
//  Rawr
//
//  Created by Galih Akbar on 02/11/24.
//

import Foundation

struct API {

    static let baseUrl = "https://api.rawg.io/api/games"

}

protocol Endpoint {

    var url: String { get }

}

enum Endpoints {

    enum Gets: Endpoint {
        case list
        case games

        public var url: String {
            switch self {
            case .list: return "\(API.baseUrl)/lists/main"
            case .games: return "\(API.baseUrl)"
            }
        }
    }

}
