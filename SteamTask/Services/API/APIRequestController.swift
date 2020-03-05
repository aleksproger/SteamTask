//
//  APIRequestController.swift
//  SteamTask
//
//  Created by Alex on 25.11.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import SwiftUI

class APIRequestController {
    struct SteamAPI {
        static let scheme =  "https"
        static let host = "api.steampowered.com"
        static let key = "92840A197B61EC2981ED15DF8F56B802"
    }
    
    func makePlayerInfoComponents() {
        
    }
    func APIgetPlayerInfo(completion: @escaping (PlayerInfo) -> Void) {
        let url = URL(string: "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=92840A197B61EC2981ED15DF8F56B802&steamids=76561198062314758")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data, let responseObject = try? decoder.decode(ResponseObject.self, from: data) {
                let profileInfo = responseObject.response.players[0]
                print(profileInfo.personaname)
                //may play with dispatch group
                DispatchQueue.main.async {
                    completion(profileInfo)
                }
            } else {
                print("Can't decode data in getPlayerInfo")
            }
        }.resume()
    }
    
    func APIloadPlayerAvatar(player: PlayerInfo, completion: @escaping (Image) -> Void) {
        let url = player.avatarfull
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            else {
                print("Can't load avatar")
            }
        }.resume()
    }
    
    func APIloadPlayerGames(completion: @escaping ([GameObject]) -> Void) {
        let url = URL(string:"https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=92840A197B61EC2981ED15DF8F56B802&steamid=76561198062314758&format=json&include_appinfo=true&count=3")!
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let responseObject = try? decoder.decode(GameResponseObject.self, from: data) {
                let games = responseObject.response.games
                
                DispatchQueue.main.async {
                    completion(games)
                }
                
            } else {
                print("Can't decode data for games")
            }
        }.resume()
    }
    
    func APIloadPlayerFriendsInfo(completion: @escaping ([FriendProfile]) -> Void) {
        let url = URL(string: "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=92840A197B61EC2981ED15DF8F56B802&steamid=76561198062314758&relationship=friend")!
         let task = URLSession.shared.dataTask(with: url) {
             (data, response, error) in
             let jsonDecoder = JSONDecoder()
             if let data = data, let responseObject = try? jsonDecoder.decode(FriendListResponseObject.self, from: data) {
                 let friends = responseObject.friendslist.friends
                 DispatchQueue.main.async {
                    completion(friends)
                 }
             }
             else {
                 print("can't fetch data for friends", error?.localizedDescription)
             }
             
         }.resume()
    }
    
    func APIloadGameIcon(game: GameObject, completion: @escaping(UIImage) -> Void) {
        let url = URL(string: "http://media.steampowered.com/steamcommunity/public/images/apps/\(game.appid)/\(game.img_icon_url).jpg")!
        
        let task = URLSession.shared.dataTask(with: url) {
             (data, response, error) in
             if let data = data, let uiImage = UIImage(data: data) {
                 DispatchQueue.main.async {
                     //print(image)
                    completion(uiImage)
                 }             }
             else {
             }
             
         }.resume()
    }
    
    func APIloadRecentGames(completion: @escaping ([RecentGame]) -> Void) {
        let url = URL(string: "http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v0001/?key=92840A197B61EC2981ED15DF8F56B802&steamid=76561198062314758&format=json")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let responseObject = try? jsonDecoder.decode(RecentlyPlayedResponseObject.self, from: data) {
                let recentGames = responseObject.response.games
                DispatchQueue.main.async {
                    completion(recentGames)
                }
            }
            else {
                print("Can't get recent games data")
            }
        }.resume()
    }
    
}
