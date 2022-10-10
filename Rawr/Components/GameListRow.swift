//
//  GameListRow.swift
//  Rawr
//
//  Created by Galih Akbar on 05/10/22.
//

import SwiftUI

struct GameListRow: View {
    let game: Game

    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                if game.backgroundImage != "" {
                    AsyncImage(url: URL(string: "\(game.backgroundImage)")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 140, height: 180)
                } else {
                    Image(systemName: "photo")
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

                PlatformIcons(platforms: game.platforms.map { $0.platform.slug })
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 180)
    }
}

struct GameListRow_Previews: PreviewProvider {
    static var previews: some View {
        GameListRow(game: exampleGame)
            .previewLayout(.sizeThatFits)
    }
}
