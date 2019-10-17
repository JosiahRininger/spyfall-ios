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

class FirestoreManager {
    typealias GameDataHandler = (GameData) -> Void
    typealias ChosenLocationHandler = (String) -> Void
    typealias LocationListHandler = ([String]) -> Void
    typealias RolesHandler = ([String]) -> Void
    typealias ListenerHandler = (Result<DocumentSnapshot, Error>) -> Void
    typealias CheckHandler = ((gameExists: Bool, usernameFree: Bool)) -> Void
    
    static let db = Firestore.firestore()
    
    // Adds a new document with a generated ID and sets the game data with the user's parameters
    static func setGameData(accessCode: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.games).document(accessCode).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
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
                print("Document does not exist")
            }
            
            guard let playerList = gameObject["playerList"],
                let playerObjectList = gameObject["playerObjectList"] as? [[String: Any]],
                let timeLimit = gameObject["timeLimit"] as? Int,
                let chosenLocation = gameObject["chosenLocation"] as? String else {
                    print("Error writing document")
                    return
            }
            gameData.timeLimit = timeLimit
            gameData.chosenLocation = chosenLocation
            
            // Store desired gameObject variables
            if let playerList = playerList as? [String] {
                gameData.playerList = playerList
            }
            
            for playerObject in playerObjectList where playerObject["username"] as? String == gameData.playerObject.username {
                gameData.playerObject = Player.dictToPlayer(with: playerObject)
            }
            gameDataReady[0] ? completion(gameData) : gameDataReady[1].toggle()
        }
    }
    
    // Retrieves the chosen location randomly from the given pack
    static func retrieveChosenLocation(chosenPack: String, completion: @escaping ChosenLocationHandler) {
        var chosenLocation = String()
        db.collection(Constants.DBStrings.packs).document(chosenPack).getDocument { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let docs = querySnapshot!.data(), let location = docs.randomElement()?.key {
                    chosenLocation = location
                }
            }
            completion(chosenLocation)
        }
    }
    
    // Retrieves all the locations within the given packs
    static func retrieveLocationList(chosenPacks: [String], completion: @escaping LocationListHandler) {
        var locationList = [String]()
        var locationDataReady = 1
        
        for pack in chosenPacks {
            self.db.collection(Constants.DBStrings.packs).document(pack).getDocument { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
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
                print("Error getting documents: \(error)")
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
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    // Deletes game
    static func deleteGame(accessCode: String) {
        db.collection(Constants.DBStrings.games).document(accessCode).delete { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
    
    // Deletes playObjectList
    static func deletePlayObjectList(accessCode: String) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(["playerObjectList": FieldValue.delete]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
    
    // Adds a listener to the game data
    static func addListener(accessCode: String, completion: @escaping ListenerHandler) {
        db.collection(Constants.DBStrings.games).document(accessCode)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    completion(.failure(error))
                }
                guard let document = documentSnapshot else {
                    print("Error fetching document")
                    return
                }
                completion(.success(document))
        }
    }
    
    // Checks if accessCode given exists and checks if the username given is taken
    static func checkGamData(accessCode: String, username: String, completion: @escaping CheckHandler) {
        var dataChecker = (gameExists: false, usernameFree: false)
        if accessCode.isEmpty || username.isEmpty {
            completion(dataChecker)
            return
        }
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error)")
            }
            if let document = document {
                if document.exists {
                    dataChecker.gameExists = true
                    if let playerList = document.data()?["playerList"] as? [String] {
                        dataChecker.usernameFree = !playerList.contains(username)
                    }
                }
            }
            completion(dataChecker)
        }
    }
}
