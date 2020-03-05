//
//  RecentlyPlayedView.swift
//  SteamTask
//
//  Created by Alex on 24.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI

struct RecentlyPlayedView: View {
    @ObservedObject var viewModel: RecentlyPlayedViewModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                List {
                    ForEach(viewModel.games) { game in
                        NavigationLink(destination: GameDetailView()) {
                            RecentlyPlayedRow(viewModel: RecentlyPlayedRowViewModel(game: game))
                        }
                    }
                }.padding()
                .navigationBarTitle("Recent games")
                //.navigationBarHidden(true)
            } 
        }
    }
}

