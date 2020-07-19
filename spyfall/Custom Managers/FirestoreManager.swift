//
//  FirestoreManager.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/19/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import FirebaseFirestore
import os.log

class FirestoreManager {
    typealias RetrieveChosenPacksAndLocationHandler = ((chosenPacks: [String], chosenLocation: String)) -> Void
    typealias LocationListHandler = ([String]) -> Void
    typealias RolesHandler = ([String]) -> Void
    typealias ListenerHandler = (Result<DocumentSnapshot, Error>) -> Void
    
    static let db = Firestore.firestore()
    
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
    
    // Retrieves all the roles for the chosen location
    static func retrieveRoles(chosenPacks: [String], chosenLocation: String, completion: @escaping RolesHandler) {
        for pack in chosenPacks {
            db.collection(Constants.DBStrings.packs).document(pack).getDocument { querySnapshot, error in
                if let error = error {
                    os_log("Error getting documents: ", log: SystemLogger.shared.logger, type: .error, error.localizedDescription)
                } else {
                    if let docs = querySnapshot!.data() as? [String: [String]] {
                        for doc in docs where doc.key == chosenLocation {
                            completion(doc.value)
                        }
                    }
                }
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
}
