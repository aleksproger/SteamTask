//
//  HomeView.swift
//  SteamTask
//
//  Created by Alex on 24.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var viewModel: ProfileViewModel
    var body: some View {
        TabView {
            ProfileView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
            }
            RecentlyPlayedView(viewModel: RecentlyPlayedViewModel())
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Recent")
            }
        }
    }
}

