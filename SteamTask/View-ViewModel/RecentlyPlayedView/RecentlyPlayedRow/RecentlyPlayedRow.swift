//
//  RecentlyPlayedRow.swift
//  SteamTask
//
//  Created by Alex on 19.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct RecentlyPlayedRow: View {
    @ObservedObject var viewModel: RecentlyPlayedRowViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 20){
            CircleImage(image: viewModel.image, diameter: 54, shadowRadius: 2)
            VStack(alignment: .leading) {
                Text(viewModel.game.name)
                    .font(.title)
                Text("Hours played: \(Int(viewModel.game.playtime_2weeks))")
                    .font(.caption)
            }
        }
        .onAppear {
            self.viewModel.icon()
        }
        .padding(.bottom, 20)
        .padding(.top, 20)
    }

    
}
