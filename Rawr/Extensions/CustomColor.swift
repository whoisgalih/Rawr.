//
//  CustomColor.swift
//  Rawr
//
//  Created by Galih Akbar on 26/09/22.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}

extension Color {
    static let lightGray: Color = Color(hex: "F5F5F5")
    static let regularGray: Color = Color(hex: "E8E8E8")
    static let darkGray: Color = Color(hex: "4C4149")

    static let textPrimary: Color = Color(hex: "251821")
    static let textSecondary: Color = Color(hex: "8E898D")

    static let redBase: Color = Color(hex: "E52A49")
    static let redMuted: Color = Color(hex: "F8E5E7")
}
