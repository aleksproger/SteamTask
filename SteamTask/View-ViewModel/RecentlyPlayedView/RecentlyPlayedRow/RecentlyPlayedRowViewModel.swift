//
//  RecentlyPlayedRowViewModel.swift
//  SteamTask
//
//  Created by Alex on 19.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class RecentlyPlayedRowViewModel: ObservableObject {
    @Published var game: RecentGame
    @Published var image = Image(systemName: "photo")
    private var dataFetcher: DataFetchable = DataFeatcher()
    private var disposables = Set<AnyCancellable>()
    init(game: RecentGame) {
        self.game = game
    }
    
    func icon() {
        _ = Just(game)
            .setFailureType(to: SteamError.self)
            .flatMap(maxPublishers: .max(1)){ (game) in
                self.dataFetcher.gameIcon(appid: "\(game.appid)", url: game.img_icon_url)
                
            }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {print($0, "getting icon for game")}, receiveValue: { image in
            self.image = image
        })
        .store(in: &disposables)
    }
}
