//
//  StatsViewModel.swift
//  spyfall
//
//  Created by Josiah Rininger on 12/6/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import FirebaseFirestore

class StatsManager {
    
    // Updates total number of games played
    static func incrementTotalNumberOfGamesPlayed() {
        var increment = 1
        #if DEBUG
        increment = 0
        #endif
        FirestoreService.updateStatData(for: Constants.DBStrings.game, data: [
            Constants.DBStrings.numberOfGamesPlayed: FieldValue.increment(Int64(increment))
        ])
    }
    
    // Updates total number of players
    static func incrementTotalNumberOfPlayers() {
        var increment = 1
        #if DEBUG
        increment = 0
        #endif
        FirestoreService.updateStatData(for: Constants.DBStrings.game, data: [
            Constants.DBStrings.numberOfPlayers: FieldValue.increment(Int64(increment))
        ])
    }
}
