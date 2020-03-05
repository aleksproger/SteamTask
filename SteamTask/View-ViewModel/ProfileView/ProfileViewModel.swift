//
//  ProfileViewViewModel.swift
//  SteamTask
//
//  Created by Alex on 17.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var avatar = Image(systemName: "photo")
    @Published var games = [GameObject]()
    @Published var personastate: PlayerInfo.State?
    @Published var friends: [FriendProfile] = []
    private let dataFetcher: DataFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(dataFetcher: DataFetchable, scheduler: DispatchQueue = DispatchQueue(label: "ProfileViewModel")) {
        self.dataFetcher = dataFetcher
        fetchProfileData()
        fetchGamesData()
        fetchFriendsProfile()
        print("started profileViewModel.init()")
    }
    
    func fetchProfileData() {
        let publisher = dataFetcher
            .profileInfo()
            .multicast { PassthroughSubject<ResponseObject, SteamError>() }
        
        _ = publisher
            .map { response in
                return (response.response.players[0].personaname,
                        response.response.players[0].personastate)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0, "getting name and status") }, receiveValue: { pair  in
            self.name = pair.0
            self.personastate = pair.1
        })
            .store(in: &disposables)
        
        _ = publisher
            .flatMap(maxPublishers: .max(1)) { response in
                self.dataFetcher.avatar(response.response.players[0].avatarfull)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {print($0, "getting profile photo")}, receiveValue: { image in
            self.avatar = image
        })
            .store(in: &disposables)
        
        
   _ = publisher
            .connect()
            .store(in: &disposables)
        

    }
    
    func fetchGamesData() {
        let publisher = dataFetcher
            .gamesInfo()
            .multicast { PassthroughSubject<GameResponseObject, SteamError>() }
        
        _ = publisher
        .map { response in
                response.response.games
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0, "getting games data") }, receiveValue: { games in
            self.games = games
        })
            .store(in: &disposables)
        
        _ = publisher
            .connect()
            .store(in: &disposables)
    }
    
    func fetchFriendsProfile() {
        let publisher = dataFetcher
        .friendList()
            .multicast { PassthroughSubject<FriendListResponseObject, SteamError>() }
        
        _ = publisher
            .map { response in
                response.friendslist.friends
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0, "getting friends profiles") }, receiveValue: { friends in
            self.friends = friends
        })
            .store(in: &disposables)
        
        _ = publisher
            .connect()
        .store(in: &disposables)
    }
}
