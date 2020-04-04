//
//  DBStrings.swift
//  spyfall
//
//  Created by Josiah Rininger on 8/26/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

extension Constants {
    /// Our firestore collection names
    struct DBStrings {
        // Strings for game data
        static let games = "games"
        static let playerList = "playerList"
        static let locationList = "locationList"
        static let playerObjectList = "playerObjectList"
        
        // Strings for pack data
        static let packs = "packs"
        static let standardPackOne = "Standard Pack 1"
        static let standardPackTwo = "Standard Pack 2"
        static let specialPackOne = "Special Pack 1"
        
        // Strings for stat data
        static let stats = "stats"
        static let game = "game"
        static let numberOfPlayers = "ios_num_of_players"
        static let numberOfGamesPlayed = "num_games_played"
    }
}
