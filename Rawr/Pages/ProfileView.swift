//
//  ProfileView.swift
//  Rawr
//
//  Created by Galih Akbar on 09/10/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    GeometryReader { geometry in
                        Image("galih")
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geometry.size.width,
                                height: geometry.frame(in: .global).minY + 404 >= 0 ?
                                    geometry.frame(in: .global).minY + 404 : 0
                            )
                            .clipped()
                            .padding(.top, -1 * geometry.frame(in: .global).minY)
                            .background(Color.regularGray)
                    }
                }
                .frame(height: 404)
                .background(Color.regularGray)
                VStack(spacing: 12) {
                    Text("Galih Akbar Nugraha")
                        .customFont(.largeTitle, .bold)
                        .multilineTextAlignment(.center)
                    Text("galihakbar.ga91@gmail.com")
                        .customFont(.title3)
                        .accentColor(.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 35)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
