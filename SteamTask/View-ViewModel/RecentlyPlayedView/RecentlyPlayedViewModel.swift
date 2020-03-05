//
//  RecentlyPlayedViewModel.swift
//  SteamTask
//
//  Created by Alex on 19.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class RecentlyPlayedViewModel: ObservableObject {
    @Published var games: [RecentGame] = []
    private var dataFetcher: DataFetchable = DataFeatcher()
    private var disposables = Set<AnyCancellable>()
    init() {
        fetchRecentlyPlayed()
    }
    func fetchRecentlyPlayed() {
        let publisher = dataFetcher
        .recentlyPlayed()
            .multicast { PassthroughSubject<RecentlyPlayedResponseObject, SteamError>() }
        
        _ = publisher
            .map { response in
                response.response.games
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0, "getting recent games")}, receiveValue: { (games) in
            self.games = games
        })
            .store(in: &disposables)
        
        _ = publisher
            .connect()
            .store(in: &disposables)
    }
}
