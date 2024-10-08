//
//  NetworkMonitor.swift
//  Rawr
//
//  Created by Galih Akbar on 08/10/24.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private var monitor = NWPathMonitor()
    private var queue = DispatchQueue.global(qos: .background)

    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
