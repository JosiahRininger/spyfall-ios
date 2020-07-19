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
    func updateGameData(with newGameData: GameData)
    func leaveGameSession(goToHomeScreen: Bool)
    func updateViews(firstPlayer: String, gameData: GameData)
    func goHome()
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
    
    // MARK: - Public Methods
    func resetGameData() {
        guard let gameData = self.gameData else { return }
        FirestoreService.resetGameData(gameData)
    }
    
    func endGame(if timerIsAtZero: Bool?) {
        guard timerIsAtZero ?? true else { return }
        FirestoreService.deleteGame(accessCode: gameData?.accessCode ?? "")
    }
    
    func deleteGame() {
        FirestoreService.deleteGame(accessCode: gameData?.accessCode ?? "")
    }
    
    deinit {
        listener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    private func beginGameSession() {
        guard let gameData = self.gameData else { return }
        FirestoreService.getUpdatedGameData(gameData: gameData) { [weak self] result in
            switch result {
            case .success(let gameData): self?.delegate?.updateGameData(with: gameData)
            case .failure(let error): print(error)
            }
        }
        listenForGameUpdates()
    }
    
    private func listenForGameUpdates() {
        guard let gameData = self.gameData else { return }
        listener = FirestoreService.addListener(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            // Successfully adds listener
            case .success(let document): self?.listenerTriggered(document)
            // Failure to add listener
            case .failure(let error):
                os_log("Firestore error: ",
                log: SystemLogger.shared.logger,
                type: .error,
                error.localizedDescription)
            }
        }
    }
    
    private func listenerTriggered(_ document: DocumentSnapshot) {
        guard let gameData = self.gameData else { return }
        var firstPlayer = String()
        if !document.exists {
            delegate?.leaveGameSession(goToHomeScreen: true)
        } else {
            if let started = document.get("started") as? Bool {
                if !started {
                    delegate?.leaveGameSession(goToHomeScreen: false)
                }
            }
            if let playerList = document.get("playerList") as? [String],
                let locationList = document.get("locationList") as? [String],
                let playerObjectList = document.get("playerObjectList") as? [[String: Any]] {
                gameData.playerList = playerList
                gameData.locationList = locationList
                gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
                firstPlayer = gameData.playerObjectList.first?.username ?? ""
                gameData.playerObjectList.shuffle()
                for playerObject in gameData.playerObjectList where playerObject.username == gameData.playerObject.username {
                    gameData.playerObject = playerObject
                }
                delegate?.updateViews(firstPlayer: firstPlayer, gameData: gameData)
            }
        }
    }
    
    // Remove current user from playerList and delete game if playerList is empty
    @objc
    private func gameInactive() {
        delegate?.goHome()
        guard let gameData = self.gameData else { return }
        switch gameData.playerList.count {
        case let x where x > 1: FirestoreService.removeUsername(accessCode: gameData.accessCode,
                                                                username: gameData.playerObject.username)
        case 1: deleteGame()
        default: return
        }
    }
}
