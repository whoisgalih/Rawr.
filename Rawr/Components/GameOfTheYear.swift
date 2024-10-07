//
//  GameOfTheYear.swift
//  Rawr
//
//  Created by Galih Akbar on 30/09/22.
//

import SwiftUI

struct GameOfTheYear: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(systemName: "photo")
                .frame(width: 195, height: 250)
                .background(Color.regularGray)
                .cornerRadius(28)
            VStack(alignment: .leading) {
                Text("Game Title")
                    .customFont(.title3)
                Spacer()
                RatingView(5.0)
            }
            .padding(28)
            HStack {
                Spacer()
                Text("#1")
                    .font(.custom("Poppins SemiBold Italic", size: 96))
                    .frame(height: 67.5)
                    .opacity(0.1)
            }
            .clipShape(RoundedCorner(radius: 28, corners: .bottomRight))
        }
        .frame(width: 195, height: 250)
    }
}

struct GameOfTheYear_Previews: PreviewProvider {
    static var previews: some View {
        GameOfTheYear()
    }
}
