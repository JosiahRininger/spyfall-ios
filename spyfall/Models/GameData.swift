//
//  GameData.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

class GameData {
    // Variable Declaration
    var accessCode: String
    var playerObject: Player
    var oldUsername: String
    var playerList: [String]
    var playerObjectList: [Player]
    var firstPlayer: String?
    var started: Bool
    var timeLimit: Int
    var chosenPacks: [String]
    var chosenLocation: String
    var locationList: [String]
    var expiration: Int64
    
    // For initializing GameData object with dummy data
    init(accessCode: String = String(),
         playerList: [String] = [String](),
         playerObject: Player = Player(role: String(), username: String(), votes: Int())) {
        self.accessCode = accessCode
        self.playerObject = playerObject
        self.oldUsername = playerObject.username
        self.playerList = playerList
        self.playerObjectList = [Player]()
        self.firstPlayer = nil
        self.started = true
        self.timeLimit = Int()
        self.chosenPacks = [String]()
        self.chosenLocation = String()
        self.locationList = [String()]
        self.expiration = Int64(Date().timeIntervalSince1970 + 21600)
    }
    
    // For initializing GameData object with actual data
    init(accessCode: String, initialPlayer: String, chosenPacks: [String], locationList: [String], timeLimit: Int, chosenLocation: String) {
        self.accessCode = accessCode
        self.playerObject = Player(role: "", username: initialPlayer, votes: 0)
        self.oldUsername = playerObject.username
        self.playerList = [initialPlayer]
        self.playerObjectList = [Player]()
        self.firstPlayer = nil
        self.started = false
        self.timeLimit = timeLimit
        self.chosenLocation = chosenLocation
        self.chosenPacks = chosenPacks
        self.locationList = locationList
        self.expiration = Int64(Date().timeIntervalSince1970 + 21600)
    }
    
    // For comparing GameData objects
    static func += (lhs: inout GameData, rhs: GameData) {
        lhs.accessCode = rhs.accessCode
        lhs.playerObject = rhs.playerObject
        lhs.oldUsername = rhs.oldUsername
        lhs.playerList = rhs.playerList
        lhs.playerObjectList = rhs.playerObjectList
        lhs.firstPlayer = rhs.firstPlayer
        lhs.started = rhs.started
        lhs.timeLimit = rhs.timeLimit
        lhs.chosenPacks = rhs.chosenPacks
        lhs.chosenLocation = rhs.chosenLocation
        lhs.locationList = rhs.locationList
        lhs.expiration = rhs.expiration
    }
    
    // Converts desired GameData properties to a dictionary for Firebase
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            Constants.DBStrings.chosenLocation: self.chosenLocation,
            Constants.DBStrings.chosenPacks: self.chosenPacks,
            Constants.DBStrings.locationList: self.locationList,
            Constants.DBStrings.playerList: self.playerList,
            Constants.DBStrings.playerObjectList: self.playerObjectList,
            Constants.DBStrings.started: self.started,
            Constants.DBStrings.timeLimit: self.timeLimit,
            Constants.DBStrings.expiration: self.expiration
        ]
        return dictionary
    }
    
    // Resets Data for a users to play again
    func resetToPlayAgain() {
        self.firstPlayer = nil
        self.playerObjectList = []
        self.started = false
    }
}
