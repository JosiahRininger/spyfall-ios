//
//  FirebaseViewModel.swift
//  spyfall
//
//  Created by Josiah Rininger on 10/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

class FirebaseViewModel {
    
    typealias SetWithLocationHandler = () -> Void
    
    public func setGameDataAndLocation(with chosenPack: String, completion: @escaping SetWithLocationHandler) {
        FirestoreManager.retrieveChosenLocation(chosenPack: chosenPack) { result in
            self.chosenLocation = result
            
            if let timeLimit = Int(self.newGameView.timeLimitTextField.text ?? "0") {
                self.timeLimit = timeLimit
            }
            
            // Add a new document with a generated ID
            FirestoreManager.setGameData(accessCode: self.accessCode, data: [
                "playerList": [self.newGameView.usernameTextField.text ?? ""],
                "timeLimit": self.timeLimit,
                "started": false,
                "chosenPacks": chosenPacks,
                "chosenLocation": self.chosenLocation
                ])
            
            completion()
        }
    }
    
}
