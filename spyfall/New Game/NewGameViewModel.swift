//
//  NewGameViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/15/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit

protocol NewGameViewModelDelegate: class {
    func newGameLoading()
    func createGameSucceeded(gameData: GameData)
    func createGameFailed()
    func showErrorMessage(_ error: SpyfallError)
}

class NewGameViewModel {
    private weak var delegate: NewGameViewModelDelegate?
    
    private var currentWorkItem: WorkItemType?
    
    init(delegate: NewGameViewModelDelegate) {
        self.delegate = delegate
    }

    // MARK: - Public Methods
    func createGame(chosenPacks: [String], initialPlayer: String, timeLimit: Int) {
        if initialPlayer.isEmpty {
            errorExist(.newGame(.usernameIsEmpty))
        } else if chosenPacks.isEmpty {
            errorExist(.newGame(.noPacksSelected))
        } else if timeLimit == -1 {
            errorExist(.newGame(.noTimeLimitSelected))
        } else if timeLimit > 10
            || timeLimit < 1 {
            errorExist(.newGame(.invalidTimeLimitSelected))
        } else {
            delegate?.newGameLoading()
            currentWorkItem = .createGame
            FirestoreService.createGame(chosenPacks: chosenPacks,
                                        initialPlayer: initialPlayer,
                                        timeLimit: timeLimit) { [weak self] result in
                                            self?.currentWorkItem = nil
                                            switch result {
                                            case .success(let gameData):
                                                self?.delegate?.createGameSucceeded(gameData: gameData)
                                            case .failure(let error):
                                                self?.errorExist(error)
                                            }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                guard self?.currentWorkItem == .createGame else { return }
                FirestoreService.cancelCreateGame()
                self?.errorExist(.network)
            }
        }
    }
    
    // MARK: - Private Methods
    private func errorExist(_ error: SpyfallError) {
        error.log()
        delegate?.createGameFailed()
        delegate?.showErrorMessage(error)
    }
}
