//
//  FriendListView.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import Combine

struct FriendListView: View {
    var friendList: [FriendProfile]
    @ObservedObject var viewModel: FriendListViewModel
    @State var showFriendsList: Bool = true
    init(friendList: [FriendProfile]) {
        UITableView.appearance().showsVerticalScrollIndicator = false
        self.friendList = friendList
        self.viewModel = FriendListViewModel(friendList: friendList)
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Friends")
                    .font(.headline)
                    .padding(.leading, 15)
                Spacer()
                Button(action: {
                    withAnimation() {
                        self.showFriendsList.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(showFriendsList ? 90 : 0))
                        .scaleEffect(showFriendsList ? 1.25 : 1)
                        .padding()
                        .animation(.easeInOut)
                }
            }
            if showFriendsList {
                List() {
                    ForEach(viewModel.friendsInfo) {
                        friendData in
                        NavigationLink(destination: FriendView(viewModel: FriendViewModel(friendData: friendData))) {
                            FriendListRow(viewModel: FriendListRowModel(info: friendData))
                        }
                    }
                }
            }
        }
    }
}

struct FriendListRow: View {
    @ObservedObject var viewModel: FriendListRowModel
    var body: some View {
        HStack(alignment: .top) {
            viewModel.image
                .resizable()
                .frame(width: 32, height: 32)
                .cornerRadius(5)
            // Spacer()
            VStack(alignment: .leading){
                Text(viewModel.info.personaname)
                    .font(.headline)
                Text(viewModel.info.personastate.description)
                    .font(.subheadline)
            }
            
            //Spacer()
        }.onAppear() {
            self.viewModel.avatar()
        }
    }
}

class FriendListRowModel: ObservableObject {
    private(set) var info: PlayerInfo
    @Published var image: Image = Image(systemName: "photo")
    private var disposables = Set<AnyCancellable>()
    private var dataFetcher: DataFetchable = DataFeatcher()
    
    init(info: PlayerInfo) {
        self.info = info
    }
    func avatar(){
        _ = Just(info)
            .setFailureType(to: SteamError.self)
            .flatMap(maxPublishers: .max(1)) { player in
                self.dataFetcher.avatar(player.avatarfull)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { print($0, "gettin avatar for friend") }, receiveValue: { image in
            self.image = image
        })
            .store(in: &disposables)
    }
    
    
}
