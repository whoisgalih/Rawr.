//
//  PaginationState.swift
//  Rawr
//
//  Created by Galih Akbar on 04/11/24.
//

import Foundation

struct PaginationState {
    var currentPage: Int
    var hasMorePages: Bool
}

class PaginationManager {
    static let shared = PaginationManager()

    private let currentPageKey = "currentPage"
    private let hasMorePagesKey = "hasMorePages"

    var currentPage: Int {
        get { UserDefaults.standard.integer(forKey: currentPageKey) }
        set { UserDefaults.standard.set(newValue, forKey: currentPageKey) }
    }

    var hasMorePages: Bool {
        get { UserDefaults.standard.bool(forKey: hasMorePagesKey) }
        set { UserDefaults.standard.set(newValue, forKey: hasMorePagesKey) }
    }

    func reset() {
        currentPage = 1
        hasMorePages = true
    }
}
