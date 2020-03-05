//
//  FriendList.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation


struct FriendListResponseObject: Codable {
    var friendslist: FriendListObject
}

struct FriendListObject: Codable {
    var friends: [FriendProfile]
}

struct FriendProfile: Codable, Identifiable {
    var steamid: String
    var id: Int {
        return Int(steamid)!
    }
    
}
