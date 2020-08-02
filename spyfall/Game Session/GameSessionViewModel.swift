//
//  GameSessionViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/16/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore
import os.log

protocol GameSessionViewModelDelegate: class {
    func beginGameSession(with newGameData: GameData)
    func leaveGameSession(goToHomeScreen: Bool)
    func updateGameSessionView(gameData: GameData)
    func showErrorFlash(_ error: SpyfallError)
}

class GameSessionViewModel {
    weak var delegate: GameSessionViewModelDelegate?
    
    private var gameData: GameData
    
    private var listener: ListenerRegistration?
    
    init(gameData: GameData) {
        self.gameData = gameData
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        gameData.setFirstPlayer()
        beginGameSession()
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    func resetGameData() {
        FirestoreService.resetGameData(gameData)
    }
    
    func endGame() {
        guard gameData.started else { return }
        FirestoreService.deleteGame(accessCode: gameData.accessCode)
    }

    func getFirstPlayer() -> String {
        return gameData.firstPlayer
    }
    
    func getPlayerList() -> [String] {
        return gameData.playerList
    }
    
    func getLocationList() -> [String] {
        return gameData.locationList
    }
    
    // MARK: - Private Methods
    private func beginGameSession() {
        gameData.playerObjectList.shuffle()
        gameData.playerList.shuffle()
        gameData.locationList.shuffle()
        FirestoreService.getUpdatedGameData(gameData: gameData) { [weak self] result in
            switch result {
            case .success(let gameData):
                self?.listenForGameUpdates()
                self?.delegate?.beginGameSession(with: gameData)
            case .failure(let error):
                SpyfallError.firestore.log(error.localizedDescription)
            }
        }
    }
    
    private func listenForGameUpdates() {
        listener = FirestoreService.addGameSessionListener(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            case .success(let updatedGameData):
                self?.listenerTriggered(updatedGameData)
            case .failure(let error):
                SpyfallError.firestore.log(error.localizedDescription)
            }
        }
    }
    
    private func listenerTriggered(_ updatedGameData: GameData?) {
        guard let updatedGameData = updatedGameData else {
                delegate?.leaveGameSession(goToHomeScreen: true)
                return
        }

        gameData.started = updatedGameData.started
        if !gameData.started {
            delegate?.leaveGameSession(goToHomeScreen: false)
            return
        }
        
        gameData.timeLimit = updatedGameData.timeLimit
        gameData.chosenLocation = updatedGameData.chosenLocation
        gameData.playerList = updatedGameData.playerList
        gameData.locationList = updatedGameData.locationList
        gameData.playerObjectList = updatedGameData.playerObjectList
        gameData.setFirstPlayer()
        
        // Retrieves first playerObject that contains currentUsername or oldUsername
        gameData.playerObject = gameData.playerObjectList
            .filter({ $0.username == gameData.playerObject.username })
            .first ?? gameData.playerObjectList
                .filter({ $0.username == gameData.oldUsername })
                .first ?? gameData.playerObject
        
        if gameData.playerList.count != gameData.playerObjectList.count
            && gameData.startedGame == gameData.playerObject.username {
            gameData.chosenLocation = gameData.locationList.shuffled().first ?? ""
            FirestoreService.retrieveRoles(chosenPacks: gameData.chosenPacks,
                                           chosenLocation: gameData.chosenLocation) { [weak self] result in
                                            switch result {
                                            case .success: self?.handleRoles(result)
                                            case .failure(let error): self?.errorExist(error)
                                            }
            }
        }
        
        delegate?.updateGameSessionView(gameData: gameData)
    }
    
    // Assigns each player a role
func handleRoles(_ result: Result<[String], SpyfallError>) {
        switch result {
        case .success(let retrievedRoles):
            var roles = retrievedRoles
            var playerList = gameData.playerList
            gameData.playerObjectList = []
            roles.shuffle()
            playerList.shuffle()
            for i in 0..<(playerList.count - 1) {
                gameData.playerObjectList.append(Player(role: roles[i], username: playerList[i], votes: 0))
            }
            gameData.playerObjectList.append(Player(role: "The Spy!", username: playerList.last ?? "", votes: 0))
            
            // Add playerObjectList field to document
            gameData.playerObjectList.shuffle()
            delegate?.updateGameSessionView(gameData: gameData)
            let playerObjectListDict = gameData.playerObjectList.map { $0.toDictionary() }
            FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerObjectList: playerObjectListDict])
            FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.chosenLocation: gameData.chosenLocation])
        case .failure(let error):
            errorExist(error)
        }
    }
    
    private func errorExist(_ error: SpyfallError) {
        error.log()
        delegate?.showErrorFlash(error)
    }
    
    // Remove current user from playerList and delete game if playerList is empty
    @objc
    private func gameInactive() {
        switch gameData.playerList.count {
        case let x where x > 1: FirestoreService.removeUsername(accessCode: gameData.accessCode,
                                                                username: gameData.playerObject.username) { [weak self] result in
                                                                    switch result {
                                                                    case .success: self?.delegate?.leaveGameSession(goToHomeScreen: true)
                                                                    case .failure(let error):
                                                                        self?.errorExist(error)
                                                                    }
            }
        case 1:
            endGame()
            delegate?.leaveGameSession(goToHomeScreen: true)
        default: return
        }
    }
}
