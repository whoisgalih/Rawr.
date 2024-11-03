//
//  GameListRow.swift
//  Rawr
//
//  Created by Galih Akbar on 03/11/24.
//

import SwiftUI
import CachedAsyncImage

struct GameRow: View {

    let game: GameModel

    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                if let url = URL(string: game.backgroundImage) {
                    // Load the image from URL if available
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 180)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 140, height: 180)
                    }
                } else {
                    // Fallback placeholder image
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 180)
                        .background(Color.gray)
                }

                RatingView(game.rating)
                    .padding(4)
                    .padding(.horizontal, 2)
                    .background(.regularMaterial)
                    .cornerRadius(8)
                    .padding(8)

            }
            .frame(width: 140, height: 180)
            .background(Color.regularGray)
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 8) {
                Text("\(game.name)")
                    .customFont(.title2, .bold)
                    .multilineTextAlignment(.leading)
                Text("\(game.released)")
                    .customFont(.body, .bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.textPrimary)
                    }

                Spacer()

                PlatformIcons(platforms: game.platforms.map { $0.slug })
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 180)
    }
}

struct GameRow_Previews: PreviewProvider {
    static var previews: some View {
        GameRow(game: exampleGameModel)
            .previewLayout(.sizeThatFits)
    }
}
