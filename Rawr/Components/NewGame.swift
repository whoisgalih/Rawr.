//
//  NewGame.swift
//  Rawr
//
//  Created by Galih Akbar on 29/09/22.
//

import SwiftUI

struct NewGame: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(systemName: "photo")
                .frame(width: 195, height: 250)
                .background(Color.regularGray)
                .cornerRadius(28)
            VStack(alignment: .leading) {
                RatingView(5.0)
                Spacer()
                Text("Game Title")
                    .customFont(.title3)
            }
            .padding(28)
        }
        .frame(width: 195, height: 250)
    }
}

struct NewGame_Previews: PreviewProvider {
    static var previews: some View {
        NewGame()
    }
}
