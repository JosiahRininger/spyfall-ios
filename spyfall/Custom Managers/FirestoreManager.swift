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
    
    static let db = Firestore.firestore()
    
    // retrieves all the game data being used on the game session controller
    static func retrieveGameData(accessCode: String, currentUsername: String, chosenPacks: [String], completion: @escaping GameDataHandler) {
        var gameData = GameData(playerObject: Player(role: String(), username: String(), votes: Int()), usernameList: [String](), timeLimit: Int(), chosenLocation: String(), locationList: [String]())
        var gameDataReady = [false, false]
        
        retrieveLocationList(chosenPacks: chosenPacks) { result in
            gameData.locationList = result
            gameDataReady[1] ? completion(gameData) : gameDataReady[0].toggle()
        }
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
            var gameObject = [String: Any]()
            if let document = document, document.exists {
                gameObject = (document.data())!
                print("Document data: \(gameObject))")
            } else {
                print("Document does not exist")
            }
            
            guard let usernameList = gameObject["playerList"],
                let playerObjectList = gameObject["playerObjectList"] as? [[String: Any]],
                let timeLimit = gameObject["timeLimit"] as? Int,
                let chosenLocation = gameObject["chosenLocation"] as? String else {
                    print("Error writing document")
                    return
            }
            gameData.timeLimit = timeLimit
            gameData.chosenLocation = chosenLocation
            
            // Store desired gameObject variables
            if let usernameList = usernameList as? [String] {
                gameData.usernameList = usernameList
            }
            
            for playerObject in playerObjectList where playerObject["username"] as? String == currentUsername {
                if let role = playerObject["role"] as? String,
                    let username = playerObject["username"] as? String,
                    let votes = playerObject["votes"] as? Int {
                    gameData.playerObject = Player(role: role,
                                                   username: username,
                                                   votes: votes)
                }
            }
            gameDataReady[0] ? completion(gameData) : gameDataReady[1].toggle()
        }
    }
    
    // retrieves the chosen location randomly from the given pack
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
    
    // retrieves all the locations within the given packs
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
    
    // retrieves all the roles for the chosen location
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
}
