//
//  SpyfallError.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/18/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Foundation
import os.log

enum NewGame: String {
    case usernameIsEmpty = "Please enter a username"
    case noPacksSelected = "Please select pack(s)"
    case noTimeLimitSelected = "Please enter a time limit"
    case invalidTimeLimitSelected = "Please enter a time limit between 1 and 10"
}

enum JoinGame: String {
    case accessCodeIsEmpty = "Please enter an access code"
    case usernameIsEmpty = "Please enter a username"
    case gameDoesNotExist = "No game with that access code"
    case usernameIsTaken = "Username is already taken"
    case gameHasAlreadyStarted = "Game has already started"
    case playersAreFull = "Game is full"
}

enum WaitingScreen: String {
    case usernameIsEmpty = "Please enter a username"
    case enteredOldUsername = "Please enter a new username"
    case usernameIsTaken = "Username is already taken"
}

enum GameSession: String {
    case unknown = "Unknown GameSession Error"
}

enum SpyfallError: Error {
    case network
    case newGame(NewGame)
    case joinGame(JoinGame)
    case waitingScreen(WaitingScreen)
    case gameSession(GameSession)
    case reachabilityNotifier
    case firestore
    case unknown
    
    var message: String {
        switch self {
        case .network: return "Network Error"
        case .newGame(let message): return message.rawValue
        case .joinGame(let message): return message.rawValue
        case .waitingScreen(let message): return message.rawValue
        case .gameSession(let message): return message.rawValue
        case .reachabilityNotifier: return "Notifier Reachability Error"
        case .firestore: return "Firestore Error"
        case .unknown: return "Unknown Error"
        }
    }
    
    @discardableResult
    func log(_ moreInfo: String? = nil) -> Self {
        let errorString = moreInfo == nil
            ? "-Spyfall Error-"
            : "-API Error: \(moreInfo ?? "Unknown")-"
        
        os_log("Error: ",
               log: SystemLogger.shared.logger,
               type: .error,
               message,
               localizedDescription,
               errorString)
        
        return self
    }
}
