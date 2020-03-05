//
//  Game+CoreDataProperties.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var icon: Data?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
