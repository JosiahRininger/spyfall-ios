//
//  GameSessionViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import GoogleMobileAds
import os.log

final class GameSessionController: UIViewController, GameSessionViewModelDelegate, GADBannerViewDelegate {

    private var scrollView = UIScrollView()
    private var gameSessionView = GameSessionView()
    private var gameSessionViewModel: GameSessionViewModel?
    private var customPopUp = EndGamePopUpView()
    private var firstPlayer = String()
    private var playerList = [String]()
    private var locationList = [String]()
    private var timer = Timer()
    private var currentTimeLeft: TimeInterval = 0.0
    private var maxTimeInterval: TimeInterval = 0.0
    private var startDate: Date?
    
#if FREE
    private var bannerView = UIElementsManager.createBannerView()
#endif
    
    init(gameData: GameData) {
        self.firstPlayer = gameData.playerObjectList.first?.username ?? ""
        gameData.playerObjectList.shuffle()
        gameData.playerList.shuffle()
        gameData.locationList.shuffle()
        playerList = gameData.playerList
        locationList = gameData.locationList
        super.init(nibName: nil, bundle: nil)
        gameSessionViewModel = GameSessionViewModel(delegate: self, gameData: gameData)
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
            self?.gameSessionViewModel?.endGame(if: self?.timerIsAtZero())
        }
        gameSessionView.playAgain.touchUpInside = { [weak self] in
            self?.gameSessionViewModel?.resetGameData()
        }
        customPopUp.endGamePopUpView.cancelButton.touchUpInside = { [weak self] in
            self?.resetViews()
        }
        customPopUp.endGamePopUpView.doneButton.touchUpInside = { [weak self] in
            self?.gameSessionViewModel?.deleteGame()
        }
    }
    
    // MARK: - Helper Methods
    private func resetViews() {
        customPopUp.isUserInteractionEnabled = false
        gameSessionView.userInfoView.isUserInteractionEnabled = true
        gameSessionView.playersCollectionView.isUserInteractionEnabled = true
        gameSessionView.locationsCollectionView.isUserInteractionEnabled = true
        gameSessionView.endGame.isUserInteractionEnabled = true
        customPopUp.endGamePopUpView.isHidden = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
    }

    private func updateCollectionViews() {
        gameSessionView.playersCollectionHeight.constant = CGFloat((playerList.count + 1) / 2) * (UIElementsManager.collectionViewCellHeight + 10)
        gameSessionView.locationsCollectionHeight.constant = CGFloat((locationList.count + 1) / 2) * (UIElementsManager.collectionViewCellHeight + 10)
        gameSessionView.playersCollectionView.reloadData()
        gameSessionView.locationsCollectionView.reloadData()
        gameSessionView.playersCollectionView.setNeedsUpdateConstraints()
        gameSessionView.locationsCollectionView.setNeedsUpdateConstraints()
        gameSessionView.playersCollectionView.layoutIfNeeded()
        gameSessionView.locationsCollectionView.layoutIfNeeded()
    }
    
    private func updateUserInfoView(gameData: GameData) {
        gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
        gameSessionView.userInfoView.locationLabel.text = gameData.playerObject.role == "The Spy!" ? "Figure out the location!" : String(format: "Location: %@", gameData.chosenLocation)
    }
    
    // MARK: - GameSessionViewModel Methods
    func updateGameData(with newGameData: GameData) {
        updateUserInfoView(gameData: newGameData)

        gameSessionView.timerLabel.text = "\(newGameData.timeLimit):00"
        maxTimeInterval = TimeInterval(newGameData.timeLimit * 60)  // Minutes * Seconds
                
        setupTimer()
        playerList = newGameData.playerList
        locationList = newGameData.locationList
        updateCollectionViews()
        
        gameSessionView.setNeedsUpdateConstraints()
        gameSessionView.layoutIfNeeded()
    }
    
    func leaveGameSession(goToHomeScreen: Bool) {
        switch goToHomeScreen {
        case true: navigationController?.popToRootViewController(animated: true)
        case false: navigationController?.popViewController(animated: true)
        }
    }
    
    func updateViews(firstPlayer: String, gameData: GameData) {
        self.firstPlayer = firstPlayer
        playerList = gameData.playerList
        locationList = gameData.locationList
        updateUserInfoView(gameData: gameData)
        updateCollectionViews()
    }
    
    func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Timer Logic
    private func setupTimer() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerFinished()
        }
    }

    private func timerFinished() {
        guard let startDate = startDate else { timer.invalidate(); return }

        let interval = Date().timeIntervalSince(startDate)
        let newTimeLeft = max(0, maxTimeInterval - interval)
        guard newTimeLeft != currentTimeLeft else { return }
        currentTimeLeft = newTimeLeft

        switch currentTimeLeft {
        case 0:
            gameSessionView.timerLabel.text = "0:00"
            timer.invalidate()
            self.startDate = nil
            gameSessionView.endGameTopAnchor.constant = UIElementsManager.buttonHeight + 48
            gameSessionView.playAgain.isHidden = false
        default:
            gameSessionView.timerLabel.text = String.timerFormat(timeInterval: currentTimeLeft)
        }
    }
    
    private func timerIsAtZero() -> Bool {
        guard currentTimeLeft != 0 else { return true }
        
        customPopUp.isUserInteractionEnabled = true
        gameSessionView.userInfoView.isUserInteractionEnabled = false
        gameSessionView.playersCollectionView.isUserInteractionEnabled = false
        gameSessionView.locationsCollectionView.isUserInteractionEnabled = false
        gameSessionView.endGame.isUserInteractionEnabled = false
        customPopUp.endGamePopUpView.isHidden = false
        scrollView.isUserInteractionEnabled = false
        scrollView.isScrollEnabled = false
        
        return false
    }
}

// MARK: - Collection View Delegate & Data Source
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
            cell.configure(username: playerList[indexPath.row], isFirstPlayer: playerList[indexPath.row] == firstPlayer)
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
