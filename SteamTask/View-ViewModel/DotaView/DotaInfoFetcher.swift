//
//  GameDataFetcher.swift
//  SteamTask
//
//  Created by Alex on 20.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

protocol DotaFetchable {
    
}

class DotaInfoFetcher: DotaFetchable {
    struct OpenDotaAPI {
        static let scheme =  "https"
        static let host = "api.opendota.com"
        static let winLosePath = "/api/players"
    }
}
