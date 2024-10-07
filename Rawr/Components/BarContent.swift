//
//  BarContent.swift
//  Rawr
//
//  Created by Galih Akbar on 07/10/24.
//


import SwiftUI

struct BarContent: View {
    var body: some View {
        Button {
            print("Profile tapped")
        } label: {
            ProfilePicture()
        }
    }
}