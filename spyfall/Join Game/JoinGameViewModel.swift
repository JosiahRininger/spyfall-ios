//
//  JoinGameViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/16/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol JoinGameViewModelDelegate: class {
    func fieldsAreValid(_ validity: GameDataValidity) -> Bool
    func gameDataUpdated(gameData: GameData)
}

class JoinGameViewModel {
    private weak var delegate: JoinGameViewModelDelegate?
    
    init(delegate: JoinGameViewModelDelegate) {
        self.delegate = delegate
    }
    
    func handleGamData(accessCode: String, username: String) {
        var validity: GameDataValidity = .AllFieldsAreValid
        if accessCode.isEmpty || username.isEmpty {
            validity = accessCode.isEmpty
                ? .accessCodeIsEmpty
                : .usernameIsEmpty
            delegate?.fieldsAreValid(validity)
            return
        }
        FirestoreService.retrieveGamData(accessCode: accessCode) { [weak self] document in
            if let document = document {
                if document.exists {
                    if let playerList = document.data()?[Constants.DBStrings.playerList] as? [String] {
                        if playerList.contains(username) { validity = .usernameIsTaken }
                        if playerList.count > 7 { validity = .playersAreFull }
                    }
                    if let started = document.data()?["started"] as? Bool {
                        if started { validity = .gameHasAlreadyStarted }
                    }
                } else {
                    validity = .gameDoesNotExist
                }
            }
            if let delegate = self?.delegate, delegate.fieldsAreValid(validity) {
                let gameData = GameData()
                gameData.accessCode = accessCode
                gameData.playerObject.username = username
                gameData.playerList = [gameData.playerObject.username]
                FirestoreService.updateGameData(accessCode: gameData.accessCode,
                                                data: [Constants.DBStrings.playerList: FieldValue.arrayUnion([gameData.playerObject.username])])
                delegate.gameDataUpdated(gameData: gameData)
            }
        }
    }
}
