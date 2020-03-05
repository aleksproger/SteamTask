//
//  FriendListViewModel.swift
//  SteamTask
//
//  Created by Alex on 18.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class FriendListViewModel: ObservableObject {
    var friendList: [FriendProfile] = []
    @Published var friendsInfo: [PlayerInfo] = []
    private var ids: [String] = []
    private var dataFetcher: DataFetchable = DataFeatcher()
    private var disposables = Set<AnyCancellable>()
    
    init(friendList: [FriendProfile]) {
        self.friendList = friendList
        ids = friendList.map { friendProfile in
            friendProfile.steamid
        }
        fetchFriendsInfo()
    }
    
    func fetchFriendsInfo() {
        let publisher = dataFetcher
            .friendsInfo(ids)
            .multicast { PassthroughSubject<ResponseObject, SteamError>() }
        
        _ = publisher
            .map { response in
                response.response.players
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0, "getting friends info") }, receiveValue: { info  in
            self.friendsInfo = info
            //print(info)
        })
            .store(in: &disposables)
        
        _ = publisher
        .connect()
        .store(in: &disposables)

    }
}
