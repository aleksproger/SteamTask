//
//  RecentlyPlayed.swift
//  SteamTask
//
//  Created by Alex on 24.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct RecentlyPlayedResponseObject: Codable {
    var response: RecentlyPlayedResponse
}

struct RecentlyPlayedResponse: Codable {
    var total_count: Int
    var games: [RecentGame]
}

struct RecentGame: Codable, Identifiable {
    var appid: Int
    var name: String
    var img_icon_url: String
    var img_logo_url: String
    var playtime_2weeks: Int
    var id: Int {
        return appid
    }
}
