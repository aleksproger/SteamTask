//
//  DataFetcher.swift
//  SteamTask
//
//  Created by Alex on 17.12.2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import SwiftUI
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, SteamError> {
    let decoder = JSONDecoder()
    //print(data)
    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}

protocol DataFetchable{
    func profileInfo() -> AnyPublisher<ResponseObject, SteamError>
    func avatar(_ url: URL) -> AnyPublisher<Image, SteamError>
    func gamesInfo() -> AnyPublisher<GameResponseObject, SteamError>
    func friendsInfo(_ ids: [String]) -> AnyPublisher<ResponseObject, SteamError>
    func friendList() -> AnyPublisher<FriendListResponseObject, SteamError>
    func recentlyPlayed() -> AnyPublisher<RecentlyPlayedResponseObject, SteamError>
    func gameIcon(appid: String, url: String) -> AnyPublisher<Image, SteamError>
}

class DataFeatcher {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension DataFeatcher: DataFetchable {
    // MARK: - Publisher for ViewModels
    func profileInfo() -> AnyPublisher<ResponseObject, SteamError> {
        return info(with: makeProfileInfoComponents(with: ""))
    }
    
    func gamesInfo() -> AnyPublisher<GameResponseObject, SteamError> {
        return info(with: makeGamesInfoComponenets(with: ""))
    }
    
    func friendsInfo(_ ids: [String]) -> AnyPublisher<ResponseObject, SteamError> {
        return info(with: makeFriendInfoComponents(with: ids))
    }
    
    func avatar(_ url: URL) -> AnyPublisher<Image, SteamError> {
        return image(with: url)
    }
    
    func friendList() -> AnyPublisher<FriendListResponseObject, SteamError> {
        return info(with: makeFriendListComponents())
    }
    
    func recentlyPlayed() -> AnyPublisher<RecentlyPlayedResponseObject, SteamError> {
        return info(with: makeRecentlyPlayedComponents())
    }
    
    func gameIcon(appid: String, url: String) -> AnyPublisher<Image, SteamError> {
        let components = makeGameIconComponents(with: appid, url: url)
        print(components.url!)
        return image(with: components.url!)
    }
    
    // MARK: - Generic info function
    private func info<T>(with components: URLComponents) -> AnyPublisher<T, SteamError> where T: Decodable {
        guard let url = components.url else {
            let error = SteamError.network(description: "Couldn't create URL.")
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        //print(url)
        return session
            .dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { (pair) in
            decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
    func image(with url: URL) -> AnyPublisher<Image, SteamError>{
        return session
            .dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { (pair) in
            self.makeImage(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
    func makeImage(_ data: Data) -> AnyPublisher<Image, SteamError> {
        return Just(data)
            .map { data -> Image in
                Image(uiImage:UIImage(data: data)!)
            }
        .mapError { error in
            .parsing(description: "Can't make image")
        }
        .eraseToAnyPublisher()
            
    }

}

private extension DataFeatcher {
    struct SteamAPI {
        static let scheme =  "https"
        static let mediaScheme = "http"
        
        static let host = "api.steampowered.com"
        static let mediaHost = "media.steampowered.com"
        
        static let key = "92840A197B61EC2981ED15DF8F56B802"
        
        static let profileInfoPath = "/ISteamUser/GetPlayerSummaries/v0002"
        static let gamesInfoPath = "/IPlayerService/GetOwnedGames/v0001"
        static let friendListPath = "/ISteamUser/GetFriendList/v0001"
        static let recentlyPlayedPath = "/IPlayerService/GetRecentlyPlayedGames/v0001"
        static let gameIconPath = "/steamcommunity/public/images/apps"
    }
    
    func makeProfileInfoComponents(
        with steamId: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamAPI.scheme
        components.host = SteamAPI.host
        components.path = SteamAPI.profileInfoPath
        
        components.queryItems = [
            URLQueryItem(name: "steamids", value: "76561198062314758"),
            URLQueryItem(name: "key", value: SteamAPI.key)
        ]
        
        return components
    }
    
    func makeGamesInfoComponenets(with steamId: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamAPI.scheme
        components.host = SteamAPI.host
        components.path = SteamAPI.gamesInfoPath
        
        components.queryItems = [
            URLQueryItem(name: "steamid", value: "76561198062314758"),
            URLQueryItem(name: "key", value: SteamAPI.key),
            URLQueryItem(name: "include_appinfo", value: "true")
        ]
        
        return components
    }
    
    func makeFriendInfoComponents(with steamids: [String]) -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamAPI.scheme
        components.host = SteamAPI.host
        components.path = SteamAPI.profileInfoPath
        
        components.queryItems = [
            URLQueryItem(name: "steamids", value: steamids.joined(separator: ",")),
            URLQueryItem(name: "key", value: SteamAPI.key),
        ]
        
        return components
    }
    
    func makeFriendListComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamAPI.scheme
        components.host = SteamAPI.host
        components.path = SteamAPI.friendListPath
        
        components.queryItems = [
            URLQueryItem(name: "steamid", value: "76561198062314758"),
            URLQueryItem(name: "relationship", value: "friend"),
            URLQueryItem(name: "key", value: SteamAPI.key),
        ]
        
        return components
    }
    
    func makeRecentlyPlayedComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = SteamAPI.scheme
        components.host = SteamAPI.host
        components.path = SteamAPI.recentlyPlayedPath
        
        components.queryItems = [
            URLQueryItem(name: "steamid", value: "76561198062314758"),
            URLQueryItem(name: "key", value: SteamAPI.key),
        ]
        
        return components
    }
    
    
    func makeGameIconComponents(with appid: String, url: String) -> URLComponents {
        var components = URLComponents()
         components.scheme = SteamAPI.mediaScheme
         components.host = SteamAPI.mediaHost
         components.path = SteamAPI.gameIconPath + "/\(appid)" + "/\(url).jpg"
         
         return components
    }

}
