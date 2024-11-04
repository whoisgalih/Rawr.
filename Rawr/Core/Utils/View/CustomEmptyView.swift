//
//  CustomEmptyView.swift
//  TheMealsApp
//
//  Created by Ari Supriatna on 08/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import SwiftUI

struct CustomEmptyView: View {
    var image: String
    var title: String

    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 100)
                .padding(.bottom, 32)

            Text(title)
                .font(.system(.body, design: .rounded))
        }
    }
}
