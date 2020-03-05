//
//  DataProvider.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import Combine

class DataProvider: ObservableObject {
    var data: [GameObject] = []
    
    @Published var snapshot: NSDiffableDataSourceSnapshot<Section, GameObject> = {
        var snap = NSDiffableDataSourceSnapshot<Section, GameObject>()
        snap.appendSections([.main])
        return snap
        }()
    
    
    func addItems(items: [GameObject], to section: Section) {
        if snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendItems(items, toSection: section)
        } else {
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
    }
}
