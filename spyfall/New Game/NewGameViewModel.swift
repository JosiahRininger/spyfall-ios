//
//  NewGameViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/15/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol NewGameViewModelDelegate: class {
    func gameDataSet(gameData: GameData)
}

class NewGameViewModel {
    private weak var delegate: NewGameViewModelDelegate?
    
    init(delegate: NewGameViewModelDelegate) {
        self.delegate = delegate
    }
    
    func createNewGame(chosenPacks: [String], initialPlayer: String, timeLimit: Int) {
        var accessCode = NSUUID().uuidString.lowercased().prefix(6)
        FirestoreService.retrieveGamData(accessCode: String(accessCode)) { [weak self] document in
            if let gameExist = document?.exists, gameExist {
                accessCode = NSUUID().uuidString.lowercased().prefix(6)
            }
            var retrieveAmount = 0
            switch chosenPacks.count {
            case 3: retrieveAmount = 5
            case 2: retrieveAmount = 7
            default: retrieveAmount = 14
            }
            FirestoreService.retrieveLocationList(chosenPacks: chosenPacks, retrieveAmount: retrieveAmount) { locationList in
                let gameData = GameData(accessCode: String(accessCode),
                                        initialPlayer: initialPlayer,
                                        chosenPacks: chosenPacks,
                                        locationList: locationList,
                                        timeLimit: timeLimit,
                                        chosenLocation: locationList.shuffled().first ?? "")
                
                // Add a new document with a generated ID
                FirestoreService.setGameData(accessCode: gameData.accessCode, data: gameData.toDictionary())
                self?.delegate?.gameDataSet(gameData: gameData)
            }
        }
    }
}
