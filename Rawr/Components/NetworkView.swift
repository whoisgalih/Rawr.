//
//  Loading.swift
//  Rawr
//
//  Created by Galih Akbar on 08/10/24.
//

import SwiftUI

struct NetworkView: View {
    @ObservedObject private var networkMonitor = NetworkMonitor()

    let height: CGFloat?

    init(height: CGFloat? = nil) {
        self.height = height
    }

    var body: some View {
        if networkMonitor.isConnected {
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: height)
        } else {
            NetworkView.noConn
        }
    }

    static var noConn: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .font(.largeTitle)
                .padding()
            Text("No internet connection")
                .font(.headline)
                .padding(.horizontal)
            Text("Please check your connection and try again.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical)
    }
}

#Preview {
    NetworkView()
}
