//
//  ContentView.swift
//  SteamTask
//
//  Created by Alex on 23.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack() {
                    CircleImage(image: viewModel.avatar)
                    VStack {
                        Text(viewModel.name).padding(.leading, 15).font(.title)
                        Text(viewModel.personastate?.description ?? "").font(.headline)
                    }
                    Spacer()
                    }
                
                if !viewModel.games.isEmpty {
                    GameRow(items: viewModel.games)
                        .padding(.bottom, 10)
                }
                
                if !viewModel.friends.isEmpty {
                    VStack {
                        FriendListView(friendList: viewModel.friends)
                    }
                }
                Spacer()
            }.padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }
    }
}


