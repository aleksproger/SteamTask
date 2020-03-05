//
//  GameRow.swift
//  SteamTask
//
//  Created by Alex on 23.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import Combine

struct GameRow: View {
    @ObservedObject var dataProvider = DataProvider()
    @State var showGames: Bool = true
    var items: [GameObject] = []
    
    init(items: [GameObject]) {
        self.items = items
        dataProvider.addItems(items: items, to: .main)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Games")
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                    .padding(.bottom, 0)
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showGames.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(showGames ? 90 : 0))
                        .scaleEffect(showGames ? 1.25 : 1)
                        .padding()
                        .animation(.easeInOut)
                }
                
            }
            if showGames {
                withAnimation {
                    UIKitCollectionView(snapshot: $dataProvider.snapshot)
                        .frame(height: 114)
                        .padding(.top, 0)
                }
            }
            
        }
        
    }
}
