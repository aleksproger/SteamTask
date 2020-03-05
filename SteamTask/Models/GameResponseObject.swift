//
//  Game.swift
//  SteamTask
//
//  Created by Alex on 23.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct GameResponseObject: Codable {
    var response: GameResponse
}

struct GameResponse: Codable {
    var game_count: Int
    var games: [GameObject]
}

struct GameObject: Codable, Identifiable, Hashable {
    var appid: Int64
    var name: String
    var img_icon_url: String
    var img_logo_url: String
    var id: Int64 {
        return appid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(appid)
    }
    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
         return lhs.id == rhs.id
     }

}


