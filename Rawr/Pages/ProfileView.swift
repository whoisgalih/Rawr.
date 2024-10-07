//
//  ProfileView.swift
//  Rawr
//
//  Created by Galih Akbar on 09/10/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userModel: UserModel
    @State private var showEditView: Bool = false
    
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
                    Text(userModel.name)
                        .customFont(.largeTitle, .bold)
                        .multilineTextAlignment(.center)
                    Text(userModel.email)
                        .customFont(.title3)
                        .accentColor(.textPrimary)
                    Text(userModel.proffesion)
                        .customFont(.headline)
                        .accentColor(.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 35)
            }
        }
        .navigationTitle("User Info")
        .toolbar {
            Button(action: {
                showEditView = true
            }, label: {
                Text("Edit")
                                .padding(8)
                                .background(.regularMaterial)
                                .cornerRadius(8)
            })
        }
        .sheet(isPresented: $showEditView) {
            ProfileEditView(userModel: userModel, showEditView: $showEditView)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userModel: UserModel())
    }
}
