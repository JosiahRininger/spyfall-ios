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
    func changeNameSucceeded()
    func leaveGame()
    func showErrorFlash(_ error: SpyfallError)
}

class WaitingScreenViewModel {
    weak var delegate: WaitingScreenViewModelDelegate?
    
    private var gameData: GameData
    
    private var listener: ListenerRegistration?
    
    private var changingName: Bool = false
    
    init(gameData: GameData) {
        self.gameData = gameData
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    // Retrieves the stored chosenPacks and ChosenLocation
    func viewDidLoad() {
        listenForGameUpdates()
        if gameData.chosenLocation.isEmpty {
            retrieveChosenPacksAndLocation()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    func retrieveChosenPacksAndLocation() {
        gameData.resetToPlayAgain()
        FirestoreService.retrieveChosenPacksAndLocation(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            case .success(let (chosenPacks, chosenLocation)):
                self?.gameData.chosenPacks = chosenPacks
                self?.gameData.chosenLocation = chosenLocation
            case .failure(let error):
                self?.errorExist(error)
            }
        }
    }
    
    func startGame() {
        guard !gameData.started else { return }
        
        gameData.started = true
        delegate?.startGameLoading()
        FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                        data: [Constants.DBStrings.started: true]) { [weak self] result in
                                            switch result {
                                            case .success:
                                                FirestoreService.retrieveRoles(chosenPacks: self?.gameData.chosenPacks ?? [],
                                                                               chosenLocation: self?.gameData.chosenLocation ?? "") { result in
                                                                                self?.handleRoles(result)
                                                }
                                            case .failure(let error):
                                                self?.errorExist(error)
                                            }
        }
    }
    
    func changeUsername(to text: String?) {
        guard !changingName else { return }
        changingName = true
        if text?.isEmpty ?? true {
            delegate?.showErrorFlash(SpyfallError.waitingScreen(.usernameIsEmpty))
            changingName = false
        } else if text == gameData.playerObject.username {
            delegate?.showErrorFlash(SpyfallError.waitingScreen(.enteredOldUsername))
            changingName = false
        } else if gameData.playerList.contains(text ?? "") {
            delegate?.showErrorFlash(SpyfallError.waitingScreen(.usernameIsTaken))
            changingName = false
        } else {
            if let text = text,
                !gameData.started {
                let newPlayerList = gameData.playerList.map { $0 == gameData.playerObject.username ? text : $0 }
                FirestoreService.changeNameInPlayerList(accessCode: gameData.accessCode, playerList: newPlayerList) { [weak self] in
                    self?.gameData.playerList = newPlayerList
                    self?.gameData.playerObject = Player(role: String(), username: text, votes: Int())
                    self?.delegate?.changeNameSucceeded()
                    self?.changingName = false
                }
            }
        }
    }
    
    func tryToLeaveGame() {
        if !gameData.started { gameInactive() }
    }
    
    func getCurrentUsername() -> String {
        return gameData.playerObject.username
    }
    
    func getPlayerList() -> [String] {
        return gameData.playerList
    }
    
    // MARK: - Private Methods
    // Assigns each player a role
    func handleRoles(_ result: Result<[String], SpyfallError>) {
        switch result {
        case .success(let retrievedRoles):
            gameData.startedGame = gameData.playerObject.username
            var roles = retrievedRoles
            var playerList = gameData.playerList
            roles.shuffle()
            playerList.shuffle()
            for i in 0..<(playerList.count - 1) {
                gameData.playerObjectList.append(Player(role: roles[i], username: playerList[i], votes: 0))
            }
            gameData.playerObjectList.append(Player(role: "The Spy!", username: playerList.last ?? "", votes: 0))
            
            // Add playerObjectList field to document
            gameData.playerObjectList.shuffle()
            let playerObjectListDict = gameData.playerObjectList.map { $0.toDictionary() }
            FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerObjectList: playerObjectListDict]) { [weak self] result in
                                                switch result {
                                                case .success: break // TODO: Handle Better
                                                case .failure(let error):
                                                    self?.errorExist(error)
                                                }
            }
            StatsManager.incrementTotalNumberOfGamesPlayed()
        case .failure(let error):
            errorExist(error)
        }
    }
    
    private func listenForGameUpdates() {
        listener = FirestoreService.addWaitingScreenListener(accessCode: gameData.accessCode) { [weak self] result in
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
                delegate?.leaveGame()
                return
        }

        gameData.timeLimit = updatedGameData.timeLimit
        gameData.playerList = updatedGameData.playerList
        gameData.started = updatedGameData.started
        if gameData.started {
            delegate?.startGameLoading()
        }
        
        delegate?.updateTableView()
        if updatedGameData.playerObjectList.count > 0 {
            delegate?.startGameLoading()
            gameData.playerObjectList = updatedGameData.playerObjectList
            delegate?.startGameSucceeded(gameData: gameData)
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
        case let x where x > 1:
            FirestoreService.removeUsername(accessCode: gameData.accessCode,
                                            username: gameData.playerObject.username) { [weak self] result in
                                                switch result {
                                                case .success: self?.delegate?.leaveGame()
                                                case .failure(let error):
                                                    self?.errorExist(error)
                                                }
            }
        case 1:
            FirestoreService.deleteGame(accessCode: gameData.accessCode)
            delegate?.leaveGame()
        default: return
        }
    }
}
