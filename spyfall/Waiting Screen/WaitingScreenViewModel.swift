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
    func startGameSucceeded(gameData: GameData)
    func updateTableView()
    func startGameLoading()
    func startGameFailed()
    func changeNameSucceeded()
    func leaveGame()
    func showErrorFlash(_ error: SpyfallError)
}

class WaitingScreenViewModel {
    private weak var delegate: WaitingScreenViewModelDelegate?
    
    private var gameData: GameData?
    
    private var listener: ListenerRegistration?
    
    init(delegate: WaitingScreenViewModelDelegate, gameData: GameData) {
        self.delegate = delegate
        self.gameData = gameData
        
        listenForGameUpdates()
        if gameData.chosenLocation.isEmpty {
            retrieveChosenPacksAndLocation()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    // Retrieves the stored chosenPacks and ChosenLocation
    func retrieveChosenPacksAndLocation() {
        guard let gameData = gameData else { return }
        gameData.resetToPlayAgain()
        FirestoreService.retrieveChosenPacksAndLocation(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            case .success(let (chosenPacks, chosenLocation)):
                gameData.chosenPacks = chosenPacks
                gameData.chosenLocation = chosenLocation
            case .failure(let error):
                self?.errorExist(error)
            }
        }
    }
    
    func startGame() {
        guard let gameData = gameData else { return }
        guard !gameData.started else { return }
        
        gameData.started = true
        delegate?.startGameLoading()
        FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                        data: [Constants.DBStrings.started: true])
        
        FirestoreService.retrieveRoles(chosenPacks: gameData.chosenPacks, chosenLocation: gameData.chosenLocation) { [weak self] roles in
            self?.handleRoles(roles)
        }
        
        StatsManager.incrementTotalNumberOfGamesPlayed()
    }
    
    func changeUsername(to text: String?) {
        guard let gameData = gameData else { return }
        if text?.isEmpty ?? true {
            delegate?.showErrorFlash(SpyfallError.waitingScreen(.usernameIsEmpty))
        } else if text == gameData.playerObject.username {
            delegate?.showErrorFlash(SpyfallError.waitingScreen(.enteredOldUsername))
        } else if gameData.playerList.contains(text ?? "") {
            delegate?.showErrorFlash(SpyfallError.waitingScreen(.usernameIsTaken))
        } else {
            if let text = text {
                let newPlayerList = gameData.playerList.map { $0 == gameData.oldUsername ? text : $0 }
                FirestoreService.changeNameInPlayerList(accessCode: gameData.accessCode, playerList: newPlayerList) { [weak self] in
                    gameData.oldUsername = gameData.playerObject.username
                    gameData.playerObject.username = text
                    self?.delegate?.changeNameSucceeded()
                }
            }
        }
    }
    
    func tryToLeaveGame() {
        if let started = gameData?.started,
            !started {
            gameInactive()
        }
    }
    
    func getCurrentUsername() -> String {
        return gameData?.playerObject.username ?? ""
    }
    
    func getPlayerList() -> [String] {
        return gameData?.playerList ?? []
    }
    
    // MARK: - Private Methods
    // Assigns each player a role
    func handleRoles(_ retrievedRoles: [String]) {
        guard let gameData = gameData else { return }
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
        FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                        data: [Constants.DBStrings.playerObjectList: playerObjectListDict])
    }
    
    private func listenForGameUpdates() {
        guard let gameData = gameData else { return }
        listener = FirestoreService.addWaitingScreenListener(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            // Successfully adds listener
            case .success(let updatedGameData):
                self?.listenerTriggered(updatedGameData)
            // Failure to add listener
            case .failure(let error):
                SpyfallError.firestore.log(error.localizedDescription)
            }
        }
    }
    
    private func listenerTriggered(_ updatedGameData: GameData?) {
        guard let gameData = self.gameData,
            let updatedGameData = updatedGameData else {
                delegate?.leaveGame()
                return
        }

        gameData.playerList = updatedGameData.playerList
        gameData.started = updatedGameData.started
        
        delegate?.updateTableView()
        if updatedGameData.playerObjectList.count != 0 {
            delegate?.startGameLoading()
        }
        if updatedGameData.playerObjectList.count == gameData.playerList.count {
            gameData.playerObjectList = updatedGameData.playerObjectList
            StatsManager.incrementTotalNumberOfPlayers()
            delegate?.startGameSucceeded(gameData: gameData)
        }
    }
    
    private func errorExist(_ error: SpyfallError) {
        error.log()
        delegate?.startGameFailed()
        delegate?.showErrorFlash(error)
    }
    
    // Remove current user from playerList and delete game if playerList is empty
    @objc
    private func gameInactive() {
        delegate?.leaveGame()
        guard let gameData = self.gameData else { return }
        switch gameData.playerList.count {
        case let x where x > 1: FirestoreService.removeUsername(accessCode: gameData.accessCode,
                                                                username: gameData.playerObject.username)
        case 1: FirestoreService.deleteGame(accessCode: gameData.accessCode)
        default: return
        }
    }
}
