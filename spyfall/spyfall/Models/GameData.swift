//
//  GameData.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

struct GameData {
    
    var playerObject: Player
    var usernameList: [String]
    var timeLimit: Int
    var chosenLocation: String
    var locationList: [String]
    
    static func +=(lhs: inout GameData, rhs: GameData) {
        lhs.playerObject = rhs.playerObject
        lhs.usernameList = rhs.usernameList
        lhs.timeLimit = rhs.timeLimit
        lhs.chosenLocation = rhs.chosenLocation
        lhs.locationList = rhs.locationList
    }
}
