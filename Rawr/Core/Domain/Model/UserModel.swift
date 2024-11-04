//
//  UserModel.swift
//  Rawr
//
//  Created by Galih Akbar on 04/11/22.
//

import Foundation

class UserModel: ObservableObject {
    private var keyName: String = "Name"
    private var keyEmail: String = "Email"
    private var keyProfession: String = "Proffession"

    @Published var name: String = String() {
        didSet {
            UserDefaults.standard.set(name, forKey: keyName)
        }
    }

    @Published var email: String = String() {
        didSet {
            UserDefaults.standard.set(email, forKey: keyEmail)
        }
    }

    @Published var proffesion: String = String() {
        didSet {
            UserDefaults.standard.set(proffesion, forKey: keyProfession)
        }
    }

    init() {
        // Get Name
        if let savedName = UserDefaults.standard.string(forKey: keyName) {
            name = savedName
        } else {
            name = "Galih Akbar Nugraha"
        }

        // Get Email
        if let savedEmail = UserDefaults.standard.string(forKey: keyEmail) {
            email = savedEmail
        } else {
            email = "galihakbar.ga91@gmail.com"
        }

        // Get Profession
        if let savedProffesion = UserDefaults.standard.string(forKey: keyProfession) {
            proffesion = savedProffesion
        } else {
            proffesion = "iOS app programmer"
        }
    }
}
