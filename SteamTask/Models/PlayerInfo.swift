//
//  PlayerInfo.swift
//  SteamTask
//
//  Created by Alex on 23.11.2019.
//  Copyright © 2019 Alex. All rights reserved.

//The user's current status. 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play. If the player's profile is private, this will always be "0", except if the user has set their status to looking to trade or looking to play, because a bug makes those status appear even if the profile is private.

import Foundation
struct ResponseObject: Codable {
    let response: Response
}

struct Response: Codable {
    let players: [PlayerInfo]
}

struct PlayerInfo: Codable, Identifiable {

    
    let personaname: String
    let avatarfull: URL
    let personastate: State
    var id = UUID()
    
    enum State: Int, Codable, CaseIterable, Hashable, CustomStringConvertible {
        case offline = 0
        case online = 1
        case busy = 2
        case away = 3
        case snooze = 4
        case lookingToTrade = 5
        case lookingToPlay = 6
        var description : String {
            switch self {
                
            case .offline: return "Offline"
            case .online: return "Online"
            case .busy: return "Busy"
            case .away: return "Away"
            case .snooze: return "Snooze"
            case .lookingToTrade: return "Looking to trade"
            case .lookingToPlay: return "Looking to play"
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case personaname
        case avatarfull
        case personastate
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        personaname = try values.decode(String.self, forKey: .personaname)
        avatarfull = try values.decode(URL.self, forKey: .avatarfull)
        personastate = try values.decode(State.self, forKey: .personastate)
        
    }
}

    
    
    
