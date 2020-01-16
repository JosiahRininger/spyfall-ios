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
    typealias ResetChosenLocationHandler = (String) -> Void
    typealias RetrieveChosenPacksAndLocationHandler = ((chosenPacks: [String], chosenLocation: String)) -> Void
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
                let locationList = gameObject[Constants.DBStrings.locationList] as? [String],
                let chosenLocation = gameObject["chosenLocation"] as? String else {
                    os_log("Error writing document")
                    return
            }
            gameData.timeLimit = timeLimit
            gameData.chosenLocation = chosenLocation
            gameData.playerList = playerList
            gameData.locationList = locationList
            
            for playerObject in playerObjectList where playerObject["username"] as? String == gameData.playerObject.username {
                gameData.playerObject = Player.dictToPlayer(with: playerObject)
            }
            completion(gameData)
        }
    }
    
    // Retrieves the chosen location randomly from the locationList
    static func resetChosenLocation(with accessCode: String, completion: @escaping ResetChosenLocationHandler) {
        var chosenLocation = String()
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
            if let document = document, document.exists {
                guard let locationList = document.data()?[Constants.DBStrings.locationList] as? [String] else {
                        os_log("Error writing document")
                        return
                }
                chosenLocation = locationList.shuffled().first ?? ""
            } else {
                os_log("Document does not exist")
            }
            completion(chosenLocation)
        }
    }
    
    // Retrieves all the chosen packs and the chosen location
    static func retrieveChosenPacksAndLocation(accessCode: String, completion: @escaping RetrieveChosenPacksAndLocationHandler) {
        var data = (chosenPacks: [String](), chosenLocation: String())
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
    
    // Retrieves 14 of the locations within the given packs
    static func retrieveLocationList(chosenPacks: [String], completion: @escaping LocationListHandler) {
        var locationList = [String]()
        var numberOfLocationsToGrab = Int()
        switch chosenPacks.count {
        case 3: numberOfLocationsToGrab = 5
        case 2: numberOfLocationsToGrab = 7
        default: numberOfLocationsToGrab = 14
        }
        for pack in chosenPacks {
            self.db.collection(Constants.DBStrings.packs).document(pack).getDocument { querySnapshot, error in
                if let error = error {
                    os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
                } else {
                    if let docs = querySnapshot!.data() {
                        let randomLocations = docs.map { $0.key }.shuffled()
                        if locationList.count == 10 { numberOfLocationsToGrab -= 1 }
                        for loc in randomLocations.indices where loc < numberOfLocationsToGrab {
                            locationList.append(randomLocations[loc])
                        }
                    }
                }
                if locationList.count == 14 { completion(locationList) }
            }
        }
    }
    
    // Retrieves all the roles for the chosen location
    static func retrieveRoles(chosenPacks: [String], chosenLocation: String, completion: @escaping RolesHandler) {
        var roles: [String] = []
        for pack in chosenPacks {
            db.collection(Constants.DBStrings.packs).document(pack).getDocument { querySnapshot, error in
                if let error = error {
                    os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
                } else {
                    if let docs = querySnapshot!.data() as? [String: [String]] {
                        for doc in docs where doc.key == chosenLocation {
                            roles = doc.value
                        }
                    }
                }
                if !roles.isEmpty { completion(roles) }
            }
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
