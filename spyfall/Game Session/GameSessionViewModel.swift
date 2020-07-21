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
    func updateViews(gameData: GameData)
}

class GameSessionViewModel {
    private weak var delegate: GameSessionViewModelDelegate?
    
    private var gameData: GameData?
    
    private var listener: ListenerRegistration?
    
    init(delegate: GameSessionViewModelDelegate, gameData: GameData) {
        self.delegate = delegate
        self.gameData = gameData
        beginGameSession()
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    func resetGameData() {
        guard let gameData = self.gameData else { return }
        FirestoreService.resetGameData(gameData)
    }
    
    func endGame() {
        FirestoreService.deleteGame(accessCode: gameData?.accessCode ?? "")
    }
    
    // MARK: - Private Methods
    private func beginGameSession() {
        guard let gameData = self.gameData else { return }
        FirestoreService.getUpdatedGameData(gameData: gameData) { [weak self] result in
            switch result {
            case .success(let gameData):
                self?.delegate?.beginGameSession(with: gameData)
            case .failure(let error):
                SpyfallError.firestore.log(error.localizedDescription)
            }
        }
        listenForGameUpdates()
    }
    
    private func listenForGameUpdates() {
        guard let gameData = self.gameData else { return }
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
        guard let gameData = self.gameData,
            let updatedGameData = updatedGameData else {
                delegate?.leaveGameSession(goToHomeScreen: true)
                return
        }

        gameData.started = updatedGameData.started
        if !gameData.started {
            delegate?.leaveGameSession(goToHomeScreen: false)
        }
        gameData.playerList = updatedGameData.playerList
        gameData.locationList = updatedGameData.locationList
        gameData.playerObjectList = updatedGameData.playerObjectList
        
        gameData.firstPlayer = gameData.playerObjectList.first?.username ?? ""
        gameData.playerObjectList.shuffle()
        for playerObject in gameData.playerObjectList where playerObject.username == gameData.playerObject.username {
            gameData.playerObject = playerObject
        }
        delegate?.updateViews(gameData: gameData)
    }
    
    // Remove current user from playerList and delete game if playerList is empty
    @objc
    private func gameInactive() {
        delegate?.leaveGameSession(goToHomeScreen: true)
        guard let gameData = self.gameData else { return }
        switch gameData.playerList.count {
        case let x where x > 1: FirestoreService.removeUsername(accessCode: gameData.accessCode,
                                                                username: gameData.playerObject.username)
        case 1: endGame()
        default: return
        }
    }
}
