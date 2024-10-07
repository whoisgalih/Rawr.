//
//  ProfilePicture.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//


import SwiftUI

struct ProfilePicture: View {
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.red, .blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 40, height: 40)
            .padding(.horizontal)
    }
}