//
//  WaitingScreenViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/17/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore
import os.log

protocol WaitingScreenViewModelDelegate: class {
    func listenToPlayerListSuccess(with document: DocumentSnapshot)
}

class WaitingScreenViewModel {
    private weak var delegate: WaitingScreenViewModelDelegate?
    
    private var listener: ListenerRegistration?
    
    init(delegate: WaitingScreenViewModelDelegate, gameData: GameData) {
        self.delegate = delegate
        listenForGameUpdates(gameData: gameData)
        if gameData.chosenLocation.isEmpty {
            retrieveChosenPacksAndLocation(gameData: gameData)
        }
    }
    
    // MARK: - Public Methods
    // Retrieves the stored chosenPacks and ChosenLocation
    func retrieveChosenPacksAndLocation(gameData: GameData) {
        FirestoreManager.retrieveChosenPacksAndLocation(accessCode: gameData.accessCode) { result in
            gameData.chosenPacks = result.chosenPacks
            gameData.chosenLocation = result.chosenLocation
        }
    }
    
    func startGame(gameData: GameData) {
        FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                        data: [Constants.DBStrings.started: true])
        
        for pack in gameData.chosenPacks {
            FirestoreService.retrievePack(pack: pack) { [weak self] document in
                if let docs = document?.data() as? [String: [String]] {
                    for doc in docs where doc.key == gameData.chosenLocation {
                        self?.handleRoles(retrievedRoles: doc.value, gameData: gameData)
                    }
                }
            }
        }
        StatsManager.incrementTotalNumberOfGamesPlayed()
    }
    
    func shouldLeaveGame(gameData: GameData) -> Bool {
        if gameData.started { return false }
        gameData.playerList.removeAll(where: { $0 == gameData.playerObject.username })
        switch gameData.playerList.isEmpty {
        case true: FirestoreService.deleteGame(accessCode: gameData.accessCode)
        case false: FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerList: FieldValue.arrayRemove([gameData.playerObject.username])])
        }
        return true
    }
    
    func handleInActive(gameData: GameData) {
        switch gameData.playerList.count {
        case let x where x > 1:
            FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerList: FieldValue.arrayRemove([gameData.playerObject.username])])
        case 1:
            FirestoreService.deleteGame(accessCode: gameData.accessCode)
        default: return
        }
    }
    
    func deleteGame(accessCode: String?) {
        FirestoreService.deleteGame(accessCode: accessCode ?? "")
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    // MARK: - Private Methods
    // Assigns each player a role
    func handleRoles(retrievedRoles: [String], gameData: GameData) {
        var roles = retrievedRoles
        gameData.playerList.shuffle()
        roles.shuffle()
        for i in 0..<(gameData.playerList.count - 1) {
            gameData.playerObjectList.append(Player(role: roles[i], username: gameData.playerList[i], votes: 0))
        }
        gameData.playerObjectList.append(Player(role: "The Spy!", username: gameData.playerList.last ?? "", votes: 0))
        
        // Add playerObjectList field to document
        gameData.playerObjectList.shuffle()
        let playerObjectListDict = gameData.playerObjectList.map { $0.toDictionary() }
        FirestoreManager.updateGameData(accessCode: gameData.accessCode,
                                        data: [Constants.DBStrings.playerObjectList: playerObjectListDict])
    }
    
    private func listenForGameUpdates(gameData: GameData) {
        listener = FirestoreService.addListener(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            // Successfully adds listener
            case .success(let document): self?.delegate?.listenToPlayerListSuccess(with: document)// self?.listenerTriggered(document, gameData)
            // Failure to add listener
            case .failure(let error):
                os_log("Firestore error: ",
                       log: SystemLogger.shared.logger,
                       type: .error,
                       error.localizedDescription)
            }
        }
    }
    
//    private func listenerTriggered(_ document: DocumentSnapshot, _ gameData: GameData) {
//        var firstPlayer = String()
//        if !document.exists {
//            delegate?.leaveGameSession(goToHomeScreen: true)
//        } else {
//            if let started = document.get("started") as? Bool {
//                if !started {
//                    delegate?.leaveGameSession(goToHomeScreen: false)
//                }
//            }
//            if let playerList = document.get("playerList") as? [String],
//                let locationList = document.get("locationList") as? [String],
//                let playerObjectList = document.get("playerObjectList") as? [[String: Any]] {
//                gameData.playerList = playerList
//                gameData.locationList = locationList
//                gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
//                firstPlayer = gameData.playerObjectList.first?.username ?? ""
//                gameData.playerObjectList.shuffle()
//                for playerObject in gameData.playerObjectList where playerObject.username == gameData.playerObject.username {
//                    gameData.playerObject = playerObject
//                }
//                delegate?.updateViews(firstPlayer: firstPlayer)
//            }
//        }
//    }
}
