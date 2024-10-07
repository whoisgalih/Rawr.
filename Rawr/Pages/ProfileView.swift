//
//  ProfileView.swift
//  Rawr
//
//  Created by Galih Akbar on 09/10/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var showEditView: Bool = false
    
    private enum CoordinateSpaces {
        case scrollView
    }
    
    var body: some View {
        ScrollView {
            ParallaxHeader(
                coordinateSpace: CoordinateSpaces.scrollView,
                defaultHeight: 300
            ) {
                Image("galih")
                    .resizable()
                    .scaledToFill()
            }
            
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
            .padding(.horizontal, 16)
            
        }
        .navigationTitle("User Info")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    showEditView = true
                }, label: {
                    Text("Edit")
                        .padding(8)
                        .background(.regularMaterial)
                        .cornerRadius(8)
                })
            }
        }
        .sheet(isPresented: $showEditView) {
            ProfileEditView(userModel: userModel, showEditView: $showEditView)
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserModel())
    }
}
