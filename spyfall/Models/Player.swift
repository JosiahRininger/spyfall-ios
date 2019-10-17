//
//  Game.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

struct Player {
    var role: String
    var username: String
    var votes: Int
    
    // Converts properties to a dictionary for Firebase
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = ["role": self.role,
                                         "username": self.username,
                                         "votes": self.votes]
        return dictionary
    }
    
    static func dictToPlayer(with playerDictionary: [String: Any]) -> Player {
        var player = Player(role: String(), username: String(), votes: Int())
        if let role = playerDictionary["role"] as? String,
            let username = playerDictionary["username"] as? String,
            let votes = playerDictionary["votes"] as? Int {
            player = Player(role: role, username: username, votes: votes)
        }
        return player
    }
    
    static func dictToPlayers(with playersDictionaries: [[String: Any]]) -> [Player] {
        var players = [Player]()
        playersDictionaries.forEach { player in
            players.append(dictToPlayer(with: player))
        }
        return players
    }
}
