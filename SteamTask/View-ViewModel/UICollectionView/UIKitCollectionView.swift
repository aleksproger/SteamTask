//
//  UIKitCollectionView.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData
import SDWebImage

enum Section: CaseIterable {
    case main
}
//let managedContext = CoreDataManager.instance.persistentContainer.viewContext
struct UIKitCollectionView: UIViewRepresentable {
    let managedContext = CoreDataManager.instance.persistentContainer.viewContext
    let requestController = APIRequestController()
    typealias UIViewType = UICollectionView
    @Binding var snapshot: NSDiffableDataSourceSnapshot<Section, GameObject>
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<UIKitCollectionView>) -> UICollectionView {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80, height: 114)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCell")
        
        let dataSource = UICollectionViewDiffableDataSource<Section, GameObject>(collectionView: collectionView) { (collectionView, indexPath, game) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCollectionViewCell
            let url = URL(string: "http://media.steampowered.com/steamcommunity/public/images/apps/\(game.appid)/\(game.img_icon_url).jpg")!
            cell.gameName.text = game.name
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "white"))
            return cell

        }
        context.coordinator.dataSource = dataSource
        return collectionView
        
    }
    
    func gameEntityExists(id: Int64) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Game.id), "\(id)")
        fetchRequest.predicate = predicate
        //fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    func loadFromCoreData(game: GameObject, context: NSManagedObjectContext, completion: @escaping (UIImage) -> Void) {
        let fetchRequest: NSFetchRequest<Game> = NSFetchRequest<Game>(entityName: "Game")
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Game.id), "\(game.appid)")
        fetchRequest.predicate = predicate
        let gamesResult = try? context.fetch(fetchRequest)
        guard let games = gamesResult else {
            print("Can't fecth games")
            return
        }
        let image = UIImage(data:games.first!.icon!)!
        completion(image)
        
    }
    
    func loadFromNetwork(game: GameObject, completion: @escaping (UIImage) -> Void) {
        requestController.APIloadGameIcon(game: game, completion: completion)
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<Section, GameObject>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GameObject>()
        snapshot.appendSections([.main])
        snapshot.appendItems([GameObject(appid: 12, name: "kekar", img_icon_url: "sda", img_logo_url: "asd")])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<UIKitCollectionView>) {
        let dataSource = context.coordinator.dataSource
        //This is where updates happen - when snapshot is changed, this function is called automatically.
        
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            //Any other things you need to do here.
        })
    }
    
    class Coordinator: NSObject {
        var parent: UIKitCollectionView
        var dataSource: UICollectionViewDiffableDataSource<Section, GameObject>?
        var snapshot = NSDiffableDataSourceSnapshot<Section, GameObject>()
        
        init(_ collectionView: UIKitCollectionView) {
            self.parent = collectionView
        }
    }
    
    
    
}

