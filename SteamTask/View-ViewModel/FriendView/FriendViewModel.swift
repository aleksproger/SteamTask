//
//  FriendViewModel.swift
//  SteamTask
//
//  Created by Alex on 27.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class FriendViewModel: ObservableObject {
    private var profileInfo: PlayerInfo
    private var disposables = Set<AnyCancellable>()
    private var dataFetcher: DataFetchable = DataFeatcher()
    @Published var name: String = ""
    @Published var personastate: PlayerInfo.State?
    @Published var avatar = Image(systemName: "photo")
    init(friendData: PlayerInfo) {
        self.profileInfo = friendData
        fetchProfile()
    }
    
    func fetchProfile() {
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
}
