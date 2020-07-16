//
//  FirestoreService.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/15/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Foundation
import FirebaseFirestore
import os.log

struct FirestoreService {
    typealias RetrieveGameDataHandler = (DocumentSnapshot?) -> Void
    typealias LocationListHandler = ([String]) -> Void
    
    static let db = Firestore.firestore()
    
    // Checks if accessCode given exists and checks if the username given is taken
    static func retrieveGamData(accessCode: String, completion: @escaping RetrieveGameDataHandler) {
        db.collection(Constants.DBStrings.games).document(accessCode).getDocument { document, error in
            if let error = error {
                os_log("Error fetching document: ",
                       log: SystemLogger.shared.logger,
                       type: .error,
                       error.localizedDescription)
            }
            completion(document)
        }
    }
    
    // Retrieves 14 of the locations within the given packs
    static func retrieveLocationList(chosenPacks: [String], retrieveAmount: Int, completion: @escaping LocationListHandler) {
        var amount = retrieveAmount
        var locationList = [String]()
        for pack in chosenPacks {
            db.collection(Constants.DBStrings.packs).document(pack).getDocument { querySnapshot, error in
                if let error = error {
                    os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
                } else {
                    if let docs = querySnapshot!.data() {
                        let randomLocations = docs.map { $0.key }.shuffled()
                        if locationList.count == 10 { amount -= 1 }
                        for loc in randomLocations.indices where loc < amount {
                            locationList.append(randomLocations[loc])
                        }
                    }
                }
                if locationList.count == 14 { completion(locationList) }
            }
        }
    }

    // Adds a new document with a generated ID and sets the game data with the user's parameters
    static func setGameData(accessCode: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.games).document(accessCode).setData(data) { error in
            if let error = error {
                os_log("Error writing document: ",
                       log: SystemLogger.shared.logger,
                       type: .error,
                       error.localizedDescription)
            }
        }
    }
    
    // Updates the game data
    static func updateGameData(accessCode: String, data: [String: Any]) {
        db.collection(Constants.DBStrings.games).document(accessCode).updateData(data) { error in
            if let error = error {
                os_log("Error writing document: ",
                       log: SystemLogger.shared.logger,
                       type: .error,
                       error.localizedDescription)
            } else {
                os_log("Document successfully written!")
            }
        }
    }
}
