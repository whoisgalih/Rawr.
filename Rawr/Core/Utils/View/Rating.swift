//
//  RatingView.swift
//  Rawr
//
//  Created by Galih Akbar on 29/09/22.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    let size: Double
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
            Text("\(String(format: "%.1f", rating))")
                .customFont(.caption)
                .font(.system(size: size))
        }
    }
    init(_ rating: Double, size: Double = 14) {
        self.rating = rating
        self.size = size
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(4.5)
            .previewLayout(.sizeThatFits)
    }
}
