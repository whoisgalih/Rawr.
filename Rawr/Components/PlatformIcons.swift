//
//  PlatformIcons.swift
//  Rawr
//
//  Created by Galih Akbar on 05/10/22.
//

import SwiftUI

struct PlatformIcons: View {
    let platforms: [String]
    let size: Double = 28

    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 4) {
                if platforms.contains("pc") {
                    Image("windows")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size, height: size)
                }

                if platforms.contains("mac") {
                    Image("apple")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size, height: size)
                }

                if platforms.contains("linux") {
                    Image("linux")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(width: size, height: size)
                }

                if platforms.contains("web") {
                    Image(systemName: "globe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(width: size, height: size)
                }

                if platforms.contains("ios") {
                    Image(systemName: "iphone")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(width: size, height: size)
                }

                if platforms.contains("android") {
                    Image("android")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(width: size, height: size)
                }

                if platforms.contains("playstation") {
                    Image("playstation")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(2)
                        .frame(width: size, height: size)
                }

                if platforms.contains("nintendo") {
                    Image("nintendo")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(width: size, height: size)
                }

                if platforms.contains("xbox") {
                    Image("xbox")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .frame(width: size, height: size)
                }
            }
        }
    }
}

struct PlatformIcons_Previews: PreviewProvider {
    static var previews: some View {
        PlatformIcons(platforms: ["pc", "mac", "linux", "web", "ios", "android", "nintendo", "playstation", "xbox"])
            .previewLayout(.sizeThatFits)
    }
}
