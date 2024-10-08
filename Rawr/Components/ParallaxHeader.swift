//
//  ParallaxHeader.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//

import SwiftUI

struct ParallaxHeader<Content: View, Space: Hashable>: View {
    let content: () -> Content
    let coordinateSpace: Space
    let defaultHeight: CGFloat

    init(
        coordinateSpace: Space,
        defaultHeight: CGFloat,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.content = content
        self.coordinateSpace = coordinateSpace
        self.defaultHeight = defaultHeight
    }

    var body: some View {
        GeometryReader { proxy in
            let offset = offset(for: proxy)
            let heightModifier = heightModifier(for: proxy)
            content()
                .edgesIgnoringSafeArea(.horizontal)
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height + heightModifier
                )
                .clipped()
                .offset(y: offset)
        }
        .frame(height: defaultHeight)
    }

    private func offset(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        if frame.minY < 0 {
            return -frame.minY * 0.8
        }
        return -frame.minY
    }

    private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return max(0, frame.minY)
    }
}

// MARK: - Preview
struct ParallaxHeader_Previews: PreviewProvider {
    private enum CoordinateSpaces {
        case scrollView
    }

    static var previews: some View {
        ScrollView {
            ParallaxHeader(coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 300) {
                Image(.example)
                    .resizable()
                    .scaledToFill()
            }

            VStack(spacing: 20) {
                ForEach(0..<20) { index in
                    Text("Content \(index)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
        }
    }
}
