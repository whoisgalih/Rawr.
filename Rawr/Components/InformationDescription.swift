//
//  InformationDescription.swift
//  Rawr
//
//  Created by Galih Akbar on 03/10/22.
//

import SwiftUI

struct InformationDescription: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(title)")
                .customFont(.subheadline, .bold)
                .foregroundColor(.textPrimary)
            Text("\(description)")
                .customFont(.subheadline)
                .foregroundColor(.textSecondary)
        }
    }
}

struct InformationDescription_Previews: PreviewProvider {
    static var previews: some View {
        InformationDescription(title: "Platform", description: "PlayStation 4, Xbox One, Xbox Series S/X, PlayStation 5, PC")
            .previewLayout(.sizeThatFits)
    }
}
