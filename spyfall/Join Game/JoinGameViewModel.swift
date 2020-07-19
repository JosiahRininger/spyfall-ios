//
//  JoinGameViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/16/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit

protocol JoinGameViewModelDelegate: class {
    func joinGameLoading()
    func networkErrorOccurred()
    func joinGameSucceeded(gameData: GameData)
    func joinGameFailed()
    func showErrorFlash(_ error: SpyfallError)
}

class JoinGameViewModel {
    private weak var delegate: JoinGameViewModelDelegate?
    
    init(delegate: JoinGameViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    func joinGame(accessCode: String, username: String) {
        delegate?.joinGameLoading()
        guard !accessCode.isEmpty else {
            errorExist(.joinGame(.accessCodeIsEmpty))
             return
         }
         guard !username.isEmpty else {
             errorExist(.joinGame(.usernameIsEmpty))
             return
         }
         FirestoreService.joinGame(accessCode: accessCode, username: username) { [weak self] result in
             switch result {
             case .success:
                 if let self = self, let delegate = self.delegate {
                     let gameData = GameData(accessCode: accessCode,
                                             playerList: [username],
                                             playerObject: Player(role: String(), username: username, votes: Int()))
                    FirestoreService.addToPlayerList(accessCode: accessCode, username: username) {
                        delegate.joinGameSucceeded(gameData: gameData)
                    }
                }
             case .failure(let error): self?.errorExist(error)
             }
         }
    }
    
    // MARK: - Private Methods
    private func errorExist(_ error: SpyfallError) {
        error.log()
        delegate?.joinGameFailed()
        delegate?.showErrorFlash(error)
    }
}
