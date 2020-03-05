//
//  SteamError.swift
//  SteamTask
//
//  Created by Alex on 17.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
enum SteamError: Error {
  case parsing(description: String)
  case network(description: String)
}
