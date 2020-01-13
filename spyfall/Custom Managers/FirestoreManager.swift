//
//  FirestoreManager.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/19/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import os.log

class FirestoreManager {
    typealias GameDataHandler = (GameData) -> Void
    typealias ChosenLocationHandler = (String) -> Void
    typealias ChosenPacksAndLocationHandler = ((chosenPacks: [String], chosenLocation: String)) -> Void
    typealias LocationListHandler = ([String]) -> Void
    typealias RolesHandler = ([String]) -> Void
    typealias ListenerHandler = (Result<DocumentSnapshot, Error>) -> Void
    typealias CheckHandler = (GameDataValidity) -> Void
    typealias GameExistHandler = (Bool) -> Void
    
    static let db = Firestore.firestore()
    
    // Adds a new document with a generated ID and sets the game data with the user's parameters
    static func setGameData(accessCode: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.games).document(accessCode).setData(data) { error in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully written!")
            }
        }
    }
    
    // Retrieves all the game data being used on the game session controller
    static func retrieveGameData(oldGameData: GameData, completion: @escaping GameDataHandler) {
        var gameData = GameData()
        gameData += oldGameData
        
        var gameDataReady = [false, false]
        
        retrieveLocationList(chosenPacks: gameData.chosenPacks) { result in
            gameData.locationList = result
            gameDataReady[1] ? completion(gameData) : gameDataReady[0].toggle()
        }
        db.collection(Constants.DBStrings.games).document(gameData.accessCode).getDocument { document, error in
            var gameObject = [String: Any]()
            if let document = document, document.exists {
                gameObject = (document.data())!
                print("Document data: \(gameObject))")
            } else {
                os_log("Document does not exist")
            }
            
            guard let playerList = gameObject[Constants.DBStrings.playerList] as? [String],
                let playerObjectList = gameObject["playerObjectList"] as? [[String: Any]],
                let timeLimit = gameObject["timeLimit"] as? Int,
                let chosenLocation = gameObject["chosenLocation"] as? String else {
                    os_log("Error writing document")
                    return
            }
            gameData.timeLimit = timeLimit
            gameData.chosenLocation = chosenLocation
            gameData.playerList = playerList
            
            for playerObject in playerObjectList where playerObject["username"] as? String == gameData.playerObject.username {
                gameData.playerObject = Player.dictToPlayer(with: playerObject)
            }
            gameDataReady[0] ? completion(gameData) : gameDataReady[1].toggle()
        }
    }
    
    // Retrieves the chosen location randomly from the given pack
    static func retrieveChosenLocation(chosenPack: String, completion: @escaping ChosenLocationHandler) {
        var chosenLocation = String()
        db.collection(Constants.DBStrings.packs).document(chosenPack).getDocument { querySnapshot, error in
            if let error = error {
                os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                if let docs = querySnapshot!.data(), let location = docs.randomElement()?.key {
                    chosenLocation = location
                }
            }
            completion(chosenLocation)
        }
    }
    
    // Retrieves all the chosen packs and the chosen location
    static func retrieveChosenPacksAndLocation(accessCode: String, completion: @escaping ChosenPacksAndLocationHandler) {
        var data = (chosenPacks: [""], chosenLocation: "")
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
            if let document = document, document.exists {
                guard let chosenPacks = document.data()?["chosenPacks"] as? [String],
                    let chosenLocation = document.data()?["chosenLocation"] as? String else {
                        os_log("Error writing document")
                        return
                }
                data = (chosenPacks: chosenPacks, chosenLocation: chosenLocation)
            } else {
                os_log("Document does not exist")
            }
            completion(data)
        }
    }
    
    // Retrieves all the locations within the given packs
    static func retrieveLocationList(chosenPacks: [String], completion: @escaping LocationListHandler) {
        var locationList = [String]()
        var locationDataReady = 1
        
        for pack in chosenPacks {
            self.db.collection(Constants.DBStrings.packs).document(pack).getDocument { querySnapshot, error in
                if let error = error {
                    os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
                } else {
                    if let docs = querySnapshot!.data() {
                        for doc in docs {
                            locationList.append(doc.key)
                        }
                    }
                }
                switch locationDataReady {
                case chosenPacks.count: completion(locationList)
                default: locationDataReady += 1
                }
            }
        }
    }
    
    // Retrieves all the roles for the chosen location
    static func retrieveRoles(chosenPack: String, chosenLocation: String, completion: @escaping RolesHandler) {
        var roles = [String]()
        db.collection(Constants.DBStrings.packs).document(chosenPack).getDocument { querySnapshot, error in
            if let error = error {
                os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                if let docs = querySnapshot!.data() as? [String: [String]] {
                    for doc in docs where doc.key == chosenLocation {
                        roles = doc.value
                    }
                }
            }
            completion(roles)
        }
    }
    
    // Updates the game data
    static func updateGameData(accessCode: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(data) { error in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully written!")
            }
        }
    }
    
    // Deletes game
    static func deleteGame(accessCode: String) {
        db.collection(Constants.DBStrings.games).document(accessCode).delete { error in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully deleted!")
            }
        }
    }
    
    // Deletes playerObjectList
    static func deletePlayerObjectList(accessCode: String) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(["playerObjectList": FieldValue.delete]) { error in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully deleted!")
            }
        }
    }
    
    // Deletes  all playerObjects
    static func deleteAllPlayerObjects(accessCode: String) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(["playerObjectList": []]) { error in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully deleted!")
            }
        }
    }
    
    // Adds a listener to the game data
    static func addListener(accessCode: String, completion: @escaping ListenerHandler) -> ListenerRegistration {
        return db.collection(Constants.DBStrings.games).document(accessCode)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    os_log("Error fetching document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
                    completion(.failure(error))
                }
                guard let document = documentSnapshot else {
                    os_log("Error fetching document")
                    return
                }
                completion(.success(document))
        }
    }
    
    // Checks if accessCode given exists and checks if the username given is taken
    static func checkGamData(accessCode: String, username: String, completion: @escaping CheckHandler) {
        var validity: GameDataValidity = .AllFieldsAreValid
        if accessCode.isEmpty || username.isEmpty {
            validity = accessCode.isEmpty
                ? .accessCodeIsEmpty
                : .usernameIsEmpty
            completion(validity)
            return
        }
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
            if let error = error {
                os_log("Error fetching document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            }
            if let document = document {
                if document.exists {
                    if let playerList = document.data()?[Constants.DBStrings.playerList] as? [String] {
                        if playerList.contains(username) { validity = .usernameIsTaken }
                        if playerList.count > 7 { validity = .playersAreFull }
                    }
                    if let started = document.data()?["started"] as? Bool {
                        if started { validity = .gameHasAlreadyStarted }
                    }
                } else {
                    validity = .gameDoesNotExist
                }
            }
            completion(validity)
        }
    }
    
    // Updates stats
    static func updateStatData(for document: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.stats).document(document).updateData(data) { error in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully written!")
            }
        }
    }
    
    // Checks if the game already exist
    static func gameExist(with accessCode: String, completion: @escaping GameExistHandler) {
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error  in
            if let error = error {
                os_log("Error writing document: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
            } else {
                os_log("Document successfully written!")
            }
            if let doc = document {
                completion(doc.exists)
            } else {
                completion(false)
            }
        }
    }
}
