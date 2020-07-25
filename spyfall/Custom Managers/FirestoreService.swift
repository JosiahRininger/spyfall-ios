//
//  FirestoreService.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/15/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Reachability
import os.log

struct FirestoreService {
    typealias RetrieveRolesHandler = ([String]) -> Void
    typealias JoinGameHandler = (Result<Void, SpyfallError>) -> Void
    typealias GameDataHandler = (Result<GameData, SpyfallError>) -> Void
    typealias RetrieveChosenHandler = (Result<([String], String), SpyfallError>) -> Void
    typealias VoidHandler = () -> Void
    typealias ListenerHandler = (Result<GameData?, Error>) -> Void
    
    static private let db = Firestore.firestore()
    static private let workItemManager = WorkItemManager()
    static private let reachability = try! Reachability()
    
    static func listenForNetworkChanges() {
        reachability.listenForNetworkChanges()
    }
    
    static func cancelCreateGame() {
        workItemManager.cancelWorkItem(for: .createGame)
    }
    
    static func cancelJoinGame() {
        workItemManager.cancelWorkItem(for: .joinGame)
    }
    
    static func cancelChangeName() {
        workItemManager.cancelWorkItem(for: .changeName)
    }
    
    static func cancelStartGame() {
        workItemManager.cancelWorkItem(for: .startGame)
    }
    
    static func cancelEndGame() {
        workItemManager.cancelWorkItem(for: .endGame)
    }
    
    static func createGame(chosenPacks: [String], initialPlayer: String, timeLimit: Int, completion: @escaping GameDataHandler) {
        switch reachability.isConnectedToNetwork {
        case .success:
            workItemManager.setWorkItem(for: .createGame,
                                        workItem: DispatchWorkItem {
                                            var accessCode = String(NSUUID().uuidString.lowercased().prefix(6))
                                            db.collection(Constants.DBStrings.games).document(accessCode).getDocument { gameDataDocument, error in
                                                if let error = error {
                                                    completion(.failure(SpyfallError.firestore.log(error.localizedDescription)))
                                                    return
                                                }
                                                if let gameExist = gameDataDocument?.exists, gameExist {
                                                    accessCode = String(NSUUID().uuidString.lowercased().prefix(6))
                                                }
                                                var locationList = [String]()
                                                var amount = 0
                                                switch chosenPacks.count {
                                                case 3: amount = 5
                                                case 2: amount = 7
                                                default: amount = 14
                                                }
                                                for pack in chosenPacks {
                                                    db.collection(Constants.DBStrings.packs).document(pack).getDocument { packDocument, error in
                                                        if let error = error {
                                                            completion(.failure(SpyfallError.firestore.log(error.localizedDescription)))
                                                            return
                                                        }
                                                        if let docs = packDocument?.data() {
                                                            let randomLocations = docs.map { $0.key }.shuffled()
                                                            if locationList.count == 10 { amount -= 1 }
                                                            for loc in randomLocations.indices where loc < amount {
                                                                locationList.append(randomLocations[loc])
                                                            }
                                                        }
                                                        if locationList.count == 14 {
                                                            let gameData = GameData(accessCode: accessCode,
                                                                                    initialPlayer: initialPlayer,
                                                                                    chosenPacks: chosenPacks,
                                                                                    locationList: locationList,
                                                                                    timeLimit: timeLimit,
                                                                                    chosenLocation: locationList.shuffled().first ?? "")
                                                            
                                                            db.collection(Constants.DBStrings.games).document(accessCode).setData(gameData.toDictionary()) { error in
                                                                if let error = error {
                                                                    completion(.failure(SpyfallError.firestore.log(error.localizedDescription)))
                                                                    return
                                                                }
                                                                completion(.success(gameData))
                                                            }
                                                        }
                                                    }
                                                }
                                            }
            }).execute()
        case .failure(let error): completion(.failure(error))
        }
    }
    
    static func joinGame(accessCode: String, username: String, completion: @escaping JoinGameHandler) {
        switch reachability.isConnectedToNetwork {
        case .success:
            workItemManager.setWorkItem(for: .joinGame,
                                        workItem: DispatchWorkItem {
                                            db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
                                                var spyfallError: SpyfallError?
                                                if let error = error {
                                                    SpyfallError.firestore.log(error.localizedDescription)
                                                }
                                                
                                                if let document = document {
                                                    if document.exists {
                                                        if let playerList = document.data()?[Constants.DBStrings.playerList] as? [String] {
                                                            if playerList.contains(username) {
                                                                spyfallError = .joinGame(.usernameIsTaken)
                                                            } else if playerList.count > 7 {
                                                                spyfallError = .joinGame(.playersAreFull)
                                                            }
                                                        } else if let started = document.data()?[Constants.DBStrings.started] as? Bool,
                                                            started {
                                                            spyfallError = .joinGame(.gameHasAlreadyStarted)
                                                        }
                                                    } else {
                                                        spyfallError = .joinGame(.gameDoesNotExist)
                                                    }
                                                }
                                                if let spyfallError = spyfallError {
                                                    completion(.failure(spyfallError))
                                                } else {
                                                    completion(.success(()))
                                                }
                                            }
            }).execute()
        case .failure(let error): completion(.failure(error))
        }
    }
    
    static func resetGameData(_ gameData: GameData) {
        DispatchQueue.main.async {
            gameData.chosenPacks.shuffle()
            db.collection(Constants.DBStrings.games).document(gameData.accessCode).getDocument { document, error in
                SpyfallError.firestore.log(error?.localizedDescription)
                if let document = document,
                    document.exists,
                    let locationList = document.data()?[Constants.DBStrings.locationList] as? [String] {
                    gameData.chosenLocation = locationList.shuffled().first ?? ""
                }
                gameData.playerObjectList = []
                gameData.started = false
                db.collection(Constants.DBStrings.games).document(gameData.accessCode).setData(gameData.toDictionary()) { error in
                     SpyfallError.firestore.log(error?.localizedDescription)
                 }
            }
        }
    }
    
    static func getUpdatedGameData(gameData: GameData, completion: @escaping GameDataHandler) {
        switch reachability.isConnectedToNetwork {
        case .success:
            var newGameData = GameData()
            newGameData += gameData
            db.collection(Constants.DBStrings.games).document(newGameData.accessCode).getDocument { document, error in
                if let document = document,
                    let gameObject = document.data(),
                    document.exists {
                    
                    guard let playerList = gameObject[Constants.DBStrings.playerList] as? [String],
                        let playerObjectList = gameObject[Constants.DBStrings.playerObjectList] as? [[String: Any]],
                        let timeLimit = gameObject[Constants.DBStrings.timeLimit] as? Int,
                        let locationList = gameObject[Constants.DBStrings.locationList] as? [String],
                        let chosenLocation = gameObject[Constants.DBStrings.chosenLocation] as? String else {
                            SpyfallError.firestore.log("Error retrieving data")
                            return
                    }
                    
                    newGameData.timeLimit = timeLimit
                    newGameData.chosenLocation = chosenLocation
                    newGameData.playerList = playerList
                    newGameData.locationList = locationList
                    
                    for playerObject in playerObjectList
                        where playerObject[Constants.DBStrings.username] as? String == newGameData.playerObject.username {
                            newGameData.playerObject = Player.dictToPlayer(with: playerObject)
                    }
                }
                completion(.success(newGameData))
            }
        case .failure(let error): completion(.failure(error))
        }
    }
    
    // Retrieves requested pack
    static func retrieveRoles(chosenPacks: [String], chosenLocation: String, completion: @escaping RetrieveRolesHandler) {
        for pack in chosenPacks {
            db.collection(Constants.DBStrings.packs).document(pack).getDocument { document, error in
                SpyfallError.firestore.log(error?.localizedDescription)
                if let docs = document?.data() as? [String: [String]] {
                    for doc in docs where doc.key == chosenLocation {
                        completion(doc.value)
                    }
                }
            }
        }
    }
    
    // Retrieves all the chosen packs and the chosen location
    static func retrieveChosenPacksAndLocation(accessCode: String, completion: @escaping RetrieveChosenHandler) {
        switch reachability.isConnectedToNetwork {
        case .success:
            db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
                if let document = document, document.exists {
                    if let chosenPacks = document.data()?[Constants.DBStrings.chosenPacks] as? [String],
                        let chosenLocation = document.data()?[Constants.DBStrings.chosenLocation] as? String {
                        completion(.success((chosenPacks, chosenLocation)))
                    } else {
                        completion(.failure(SpyfallError.firestore))
                    }
                }
            }
        case .failure(let error): completion(.failure(error))
        }
    }
    
    // Updates the game data
    static func updateGameData(accessCode: String, data: [String: Any], completion: @escaping VoidHandler) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(data) { error in
            SpyfallError.firestore.log(error?.localizedDescription)
            completion()
        }
    }
    
    // Updates the game data
    static func updateGameData(accessCode: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(data) { error in
            SpyfallError.firestore.log(error?.localizedDescription)
        }
    }
    
    // Updates the game data
    static func removeUsername(accessCode: String, username: String) {
        db.collection(Constants.DBStrings.games).document(accessCode)
            .updateData([Constants.DBStrings.playerList: FieldValue.arrayRemove([username])]) { error in
                SpyfallError.firestore.log(error?.localizedDescription)
        }
    }
    
    // Updates the game data
    static func addToPlayerList(accessCode: String, username: String, completion: @escaping VoidHandler) {
        db.collection(Constants.DBStrings.games).document(accessCode)
            .updateData([Constants.DBStrings.playerList: FieldValue.arrayUnion([username])]) { error in
                SpyfallError.firestore.log(error?.localizedDescription)
                completion()
        }
    }
    
    // Updates playerList with changed name
    static func changeNameInPlayerList(accessCode: String, playerList: [String], completion: @escaping VoidHandler) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData([Constants.DBStrings.playerList: playerList]) { error in
            SpyfallError.firestore.log(error?.localizedDescription)
            completion()
        }
    }
    
    // Deletes game
    static func deleteGame(accessCode: String) {
        db.collection(Constants.DBStrings.games).document(accessCode).delete { error in
            SpyfallError.firestore.log(error?.localizedDescription)
        }
    }

    static func addWaitingScreenListener(accessCode: String, completion: @escaping ListenerHandler) -> ListenerRegistration {
        return db.collection(Constants.DBStrings.games).document(accessCode)
            .addSnapshotListener { documentSnapshot, error in
                SpyfallError.firestore.log(error?.localizedDescription)
                guard let document = documentSnapshot else {
                    SpyfallError.firestore.log("Error fetching document: DocumentSnapshot was nil")
                    return
                }
                let gameData = GameData()
                if !document.exists {
                    completion(.success(nil))
                } else {
                    if let started = document.get(Constants.DBStrings.started) as? Bool,
                        let playerList = document.get(Constants.DBStrings.playerList) as? [String] {
                        gameData.playerList = playerList
                        gameData.started = started
                    }
                    if let playerObjectList = document.get(Constants.DBStrings.playerObjectList) as? [[String: Any]] {
                        gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
                    }
                }
                completion(.success(gameData))
        }
    }
    
    // Adds a listener to the game data
    static func addGameSessionListener(accessCode: String, completion: @escaping ListenerHandler) -> ListenerRegistration {
        return db.collection(Constants.DBStrings.games).document(accessCode)
            .addSnapshotListener { documentSnapshot, error in
                SpyfallError.firestore.log(error?.localizedDescription)
                guard let document = documentSnapshot else {
                    SpyfallError.firestore.log("Error fetching document: DocumentSnapshot was nil")
                    return
                }
                let gameData = GameData()
                if !document.exists {
                    completion(.success(nil))
                } else {
                    if let started = document.get(Constants.DBStrings.started) as? Bool {
                        gameData.started = started
                        if let playerList = document.get(Constants.DBStrings.playerList) as? [String],
                            let locationList = document.get(Constants.DBStrings.locationList) as? [String],
                            let playerObjectList = document.get(Constants.DBStrings.playerObjectList) as? [[String: Any]] {
                            gameData.playerList = playerList
                            gameData.locationList = locationList
                            gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
                        }
                        completion(.success(gameData))
                    }
                }
        }
    }
    
    // Updates stats
    static func updateStatData(for document: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.stats).document(document).updateData(data) { error in
            SpyfallError.firestore.log(error?.localizedDescription)
        }
    }
}
