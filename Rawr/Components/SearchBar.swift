//
//  Extensions.swift
//  Rawr
//
//  Created by Galih Akbar on 27/09/22.
//

import SwiftUI

struct SearchTextFiledStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 27)
            .padding(.leading, 36)
            .padding(.vertical, 20)
            .background(Color.lightGray)
            .cornerRadius(20)
    }
}

struct SearchBarPreview: View {
    @State var seacrhInput: String = ""
    
    var body: some View {
        VStack {
            TextField("Search games", text: $seacrhInput)
                .customFont(.caption)
                .textFieldStyle(SearchTextFiledStyle())
                .overlay(alignment: .leading) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 27)
                        .foregroundColor(.textSecondary)
                }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarPreview()
            .previewLayout(.sizeThatFits)
    }
}

