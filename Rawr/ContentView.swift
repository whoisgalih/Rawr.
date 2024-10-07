//
//  ContentView.swift
//  Rawr
//
//  Created by Galih Akbar on 18/09/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userModel = UserModel()
    
    
    var body: some View {
        GamesListPage(userModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
