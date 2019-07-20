//
//  NetworkManager.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/19/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

class NetworkManager {
    typealias GameDataHandler = (GameData) -> Void
    typealias LocationListHandler = ([String]) -> Void
    
    static let db = Firestore.firestore()
    
    static func retrieveGameData(accessCode: String, currentUsername: String, chosenPacks: [String], completion: @escaping GameDataHandler) {
        
        var gameData = GameData(playerObject: Player(role: String(), username: String(), votes: Int()), usernameList: [String](), timeLimit: Int(), chosenLocation: String(), locationList: [String]())
        var gameDataReady = [false, false]
        
        retrieveLocationList(chosenPacks: chosenPacks, completion: { result in
            gameData.locationList = result
            gameDataReady[1] ? completion(gameData) : gameDataReady[0].toggle()
        })
        db.collection("games").document(accessCode).getDocument { document, error in
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
    
    static func retrieveLocationList(chosenPacks: [String], completion: @escaping LocationListHandler) {
        var locationList = [String]()
        var locationDataReady = 1
        
        for pack in chosenPacks {
            self.db.collection(pack).getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
                        locationList.append(doc.documentID as String) }
                }
                
                switch locationDataReady {
                case chosenPacks.count: completion(locationList)
                default: locationDataReady += 1
                }
                
            }
        }
    }
    
}
