//
//  ProfileEditView.swift
//  Rawr
//
//  Created by Galih Akbar on 06/11/22.
//

import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var userModel: UserModel
    @Binding var showEditView: Bool
    @State private var name: String
    @State private var email: String
    @State private var proffesion: String
    
    init(userModel: UserModel, showEditView: Binding<Bool>) {
        self.userModel = userModel
        self.name = userModel.name
        self.email = userModel.email
        self.proffesion = userModel.proffesion
        self._showEditView = showEditView
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("User Information")) {
                    TextField(
                        "Name",
                        text: $name
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    
                    TextField(
                        "Email",
                        text: $email
                    )
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    
                    TextField(
                        "Profession",
                        text: $proffesion
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
            }
            .navigationTitle("Edit User Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showEditView = false
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        userModel.name = name
                        userModel.email = email
                        userModel.proffesion = proffesion
                        
                        showEditView = false
                    }
                }
            }
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(userModel: UserModel(), showEditView: .constant(true))
    }
}
