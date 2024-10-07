//
//  Category.swift
//  Rawr
//
//  Created by Galih Akbar on 28/09/22.
//

import SwiftUI

struct Category: View {
    let name: String
    let icon: Image
    let active: Bool
    
    var body: some View {
        HStack {
            icon
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding(4)
                .background(Color.white)
                .cornerRadius(20)
            Text("\(name)")
                .customFont(.caption, .bold)
        }
        .foregroundColor(active ? .redBase : .textPrimary)
        .padding([.vertical, .leading], 4)
        .padding(.trailing, 16)
        .background(active ? Color.redMuted : Color.lightGray)
        .cornerRadius(20)
    }
}

struct Category_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Category(name: "Action", icon: Image("sword"), active: true)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Active")
            Category(name: "Action", icon: Image("sword"), active: false)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Inactive")
        }
    }
}
