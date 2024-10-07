//
//  TrendingGame.swift
//  Rawr
//
//  Created by Galih Akbar on 28/09/22.
//

import SwiftUI

struct TrendingGame: View {
    let platforms: [String]
    let gameTitle: String
    let gameImage: Image
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: -66) {
                Image(systemName: "photo")
                    .frame(width: 260, height: 369)
                    .background(Color.regularGray)
                    .cornerRadius(28)
                VStack(spacing: 10) {
                    Text("Game Title")
                        .customFont(.title2, .bold)
                    HStack(alignment: .center, spacing: 4) {
                        PlatformIcons(platforms: platforms)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.forward")
                            .frame(width: 28, height: 28)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.darkGray)
                    .foregroundColor(.white)
                    .cornerRadius(28)
                .padding(.horizontal, 28)
                }
            }
            RatingView(4.5)
                .padding(28)
        }
        .frame(width: 260)
    }
}

struct TrendingGame_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TrendingGame(platforms: ["pc", "mac"], gameTitle: "Game Title", gameImage: Image(systemName: "photo"))
        }
        .previewLayout(.sizeThatFits)
    }
}
