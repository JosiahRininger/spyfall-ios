//
//  GameData.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

class GameData {
    
    // Static variables created to check current game data in the AppDelegate
    static var staticPlayerListCount: Int = 0
    static var staticCurrentUsername: String = ""
    static var staticAccessCode: String = ""
    
    // Variable Declaration
    var accessCode: String {
        didSet(newValue) {
            GameData.staticAccessCode = newValue
        }
    }
    var playerObject: Player {
        didSet(newValue) {
            GameData.staticCurrentUsername = newValue.username
        }
    }
    var playerList: [String] {
        didSet(newValue) {
            GameData.staticPlayerListCount = newValue.count
        }
    }
    var playerObjectList: [Player]
    var started: Bool
    var seguedToGameSession: Bool
    var timeLimit: Int
    var chosenPacks: [String]
    var chosenLocation: String
    var locationList: [String]
    
    // For initializing GameData object with dummy data
    init() {
        self.accessCode = String()
        self.playerObject = Player(role: String(), username: String(), votes: Int())
        self.playerList = [String]()
        self.playerObjectList = [Player]()
        self.started = true
        self.seguedToGameSession = false
        self.timeLimit = Int()
        self.chosenPacks = [String]()
        self.chosenLocation = String()
        self.locationList = [String()]
    }
    
    // For initializing GameData object with actual data
    init(accessCode: String, initialPlayer: String, chosenPacks: [String], timeLimit: Int, chosenLocation: String) {
        self.accessCode = accessCode
        self.playerObject = Player(role: "", username: initialPlayer, votes: 0)
        self.playerList = [initialPlayer]
        self.playerObjectList = [Player]()
        self.started = false
        self.seguedToGameSession = false
        self.timeLimit = timeLimit
        self.chosenPacks = chosenPacks
        self.chosenLocation = chosenLocation
        self.locationList = []
    }
    
    // For comparing GameData objects
    static func += (lhs: inout GameData, rhs: GameData) {
        lhs.accessCode = rhs.accessCode
        lhs.playerObject = rhs.playerObject
        lhs.playerList = rhs.playerList
        lhs.playerObjectList = rhs.playerObjectList
        lhs.started = rhs.started
        lhs.seguedToGameSession = rhs.seguedToGameSession
        lhs.timeLimit = rhs.timeLimit
        lhs.chosenPacks = rhs.chosenPacks
        lhs.chosenLocation = rhs.chosenLocation
        lhs.locationList = rhs.locationList
    }
    
    // Converts desired GameData properties to a dictionary for Firebase
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "chosenLocation": self.chosenLocation,
            "chosenPacks": self.chosenPacks,
            Constants.DBStrings.playerList: self.playerList,
            "playerObjectList": self.playerObjectList,
            "started": self.started,
            "timeLimit": self.timeLimit
        ]
        return dictionary
    }
    
    // Resets Data for a users to play again
    func resetToPlayAgain() {
        self.playerObjectList = []
        self.started = false
        self.seguedToGameSession = false
    }
}
