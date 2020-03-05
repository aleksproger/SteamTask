//
//  CoreDataManager.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    static let instance = CoreDataManager()
    private init() {}
    
    func deletePreviousData() {
        let gameRequest: NSFetchRequest<NSFetchRequestResult> = Game.fetchRequest()
 
        
        let batchDeleteGame = NSBatchDeleteRequest(fetchRequest: gameRequest)
        batchDeleteGame.resultType = .resultTypeCount
        
        do {
            let gameResult = try managedContext.execute(batchDeleteGame) as! NSBatchDeleteResult
            print("Deleted \(gameResult.result)")
        } catch {
            print(error)
        }
        try! managedContext.save()
    }
    
    lazy var managedContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SteamTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
