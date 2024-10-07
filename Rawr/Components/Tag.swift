//
//  GameTag.swift
//  Rawr
//
//  Created by Galih Akbar on 03/10/22.
//

import SwiftUI

struct Tag: View {
    let tag: String
    var body: some View {
        Text("\(tag)")
            .customFont(.caption, .bold)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke()
            }
    }

    init(_ tag: String) {
        self.tag = tag
    }
}

struct Tag_Previews: PreviewProvider {
    static var previews: some View {
        Tag("Action")
            .previewLayout(.sizeThatFits)
    }
}
