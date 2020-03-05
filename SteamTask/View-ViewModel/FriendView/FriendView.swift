//
//  FriendView.swift
//  SteamTask
//
//  Created by Alex on 27.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import Combine

struct FriendView: View {
    @ObservedObject var viewModel: FriendViewModel
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                CircleImage(image: viewModel.avatar)
                VStack() {
                    Text(viewModel.name).padding(.leading, 15).font(.title)
                    Text(viewModel.personastate?.description ?? "").font(.headline)
                }
            }
            
            Spacer()
        }.padding()
            .navigationBarTitle("")
        
    }
}

