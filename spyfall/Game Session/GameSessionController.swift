//
//  GameSessionViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class GameSessionController: UIViewController, GameSessionViewModelDelegate, GameTimerDelegate, GADBannerViewDelegate {

    private var scrollView = UIScrollView()
    private var gameSessionView = GameSessionView()
    private var gameSessionViewModel: GameSessionViewModel
    private var customPopUp = EndGamePopUpView()
    private var gameTimer: GameTimer?
    private var playerList: [String] { gameSessionViewModel.getPlayerList() }
    private var locationList: [String] { gameSessionViewModel.getLocationList() }

#if FREE
    private var bannerView = UIElementsManager.createBannerView()
#endif
    
    init(gameData: GameData) {
        gameSessionViewModel = GameSessionViewModel(gameData: gameData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSessionView.playersCollectionView.delegate = self
        gameSessionView.playersCollectionView.dataSource = self
        gameSessionView.locationsCollectionView.delegate = self
        gameSessionView.locationsCollectionView.dataSource = self
        gameSessionViewModel.delegate = self
        gameSessionViewModel.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        scrollView.backgroundColor = .primaryBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(gameSessionView)
        view.backgroundColor = .primaryBackgroundColor
        view.addSubviews(scrollView, customPopUp)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gameSessionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            gameSessionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            gameSessionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            gameSessionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
#if FREE
        view.addSubview(bannerView)
        bannerView.delegate = self
        bannerView.adUnitID = Constants.IDs.gameSessionAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
#endif
    }
    
    private func setupButtons() {
        gameSessionView.endGame.touchUpInside = { [weak self] in
            if self?.gameSessionView.playAgain.isHidden ?? true {
                self?.endGamePopUp(shouldHide: false)
            } else {
                self?.gameSessionViewModel.endGame()
            }
        }
        gameSessionView.playAgain.touchUpInside = { [weak self] in
            self?.gameSessionViewModel.resetGameData()
        }
        customPopUp.endGamePopUpView.cancelButton.touchUpInside = { [weak self] in
            self?.endGamePopUp(shouldHide: true)
        }
        customPopUp.endGamePopUpView.doneButton.touchUpInside = { [weak self] in
            self?.gameSessionViewModel.endGame()
        }
    }
    
    // MARK: - Helper Methods
    private func endGamePopUp(shouldHide: Bool) {
        gameSessionView.isUserInteractionEnabled = shouldHide
        scrollView.isUserInteractionEnabled = shouldHide
        customPopUp.isHidden = shouldHide
    }
    
    // MARK: - GameSessionViewModel Methods
    func beginGameSession(with newGameData: GameData) {
        gameTimer = GameTimer(delegate: self, timeLimit: newGameData.timeLimit)
        updateGameSessionView(gameData: newGameData)

        gameSessionView.timerLabel.text = "\(newGameData.timeLimit):00"
        gameSessionView.layoutIfNeeded()
    }
    
    func leaveGameSession(goToHomeScreen: Bool) {
        switch goToHomeScreen {
        case true: navigationController?.popToRootViewController(animated: true)
        case false: navigationController?.popViewController(animated: true)
        }
    }
    
    func updateGameSessionView(gameData: GameData) {
        gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
        gameSessionView.userInfoView.locationLabel.text = gameData.playerObject.role == "The Spy!" ? "Figure out the location!" : String(format: "Location: %@", gameData.chosenLocation)
        
        gameSessionView.playersCollectionHeight.constant = CGFloat((playerList.count + 1) / 2) * (UIElementsManager.collectionViewCellHeight + 10)
        gameSessionView.locationsCollectionHeight.constant = CGFloat((locationList.count + 1) / 2) * (UIElementsManager.collectionViewCellHeight + 10)
        gameSessionView.playersCollectionView.updateConstraintsIfNeeded()
        gameSessionView.playersCollectionView.updateConstraintsIfNeeded()
        gameSessionView.playersCollectionView.reloadData()
        gameSessionView.locationsCollectionView.reloadData()
        gameSessionView.layoutIfNeeded()
    }
    
    func showErrorFlash(_ error: SpyfallError) {
        switch error {
        case SpyfallError.network: ErrorManager.showPopUp(for: view)
        default: ErrorManager.showFlash(with: error.message)
        }
    }
    
    // MARK: - GameTimer Methods
    func updateTimerLabel(with timeLeft: TimeInterval) {
        gameSessionView.timerLabel.text = String.timerFormat(timeInterval: timeLeft)
    }

    func timerFinished() {
        gameSessionView.timerLabel.text = "0:00"
        gameSessionView.endGameTopAnchor.constant = UIElementsManager.buttonHeight + 48
        gameSessionView.playAgain.isHidden = false
    }
}

// MARK: - CollectionView Delegate & Data Source
extension GameSessionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case gameSessionView.playersCollectionView:
            return playerList.count
        default:
            return locationList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case gameSessionView.playersCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.playersCollectionViewCellId, for: indexPath) as? PlayersCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(username: playerList[indexPath.row],
                           isFirstPlayer: playerList[indexPath.row] == gameSessionViewModel.getFirstPlayer())
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.locationsCollectionViewCellId, for: indexPath) as? LocationsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(location: locationList[indexPath.row])
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case gameSessionView.playersCollectionView:
            let cell = gameSessionView.playersCollectionView.cellForItem(at: indexPath) as? PlayersCollectionViewCell
            cell?.isTapped.toggle()
        default:
            let cell = gameSessionView.locationsCollectionView.cellForItem(at: indexPath) as? LocationsCollectionViewCell
            cell?.isTapped.toggle()
        }
    }
}

extension GameSessionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 14) / 2, height: UIElementsManager.collectionViewCellHeight)
    }
}
