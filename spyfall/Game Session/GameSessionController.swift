//
//  GameSessionViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds
import os.log

final class GameSessionController: UIViewController, GADBannerViewDelegate {

    var scrollView = UIScrollView()
    var gameSessionView = GameSessionView()
    var customPopUp = EndGamePopUpView()
    
#if FREE
    var bannerView = UIElementsManager.createBannerView()
#endif
    
    private var gameData = GameData()
    private var firstPlayer = String()
    private var listener: ListenerRegistration?

    private var timer = Timer()
    private var currentTimeLeft: TimeInterval = 0.0
    private var maxTimeInterval: TimeInterval = 0.0
    private var startDate: Date?
    
    init(gameData: GameData) {
        self.gameData = gameData
        self.firstPlayer = self.gameData.playerObjectList.first?.username ?? ""
        self.gameData.playerObjectList.shuffle()
        self.gameData.playerList.shuffle()
        self.gameData.locationList.shuffle()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirestoreManager.retrieveGameData(oldGameData: self.gameData) { [weak self] result in
            self?.gameData += result
            self?.updateGameData()
        }
        
        gameSessionView.playersCollectionView.delegate = self
        gameSessionView.playersCollectionView.dataSource = self
        gameSessionView.locationsCollectionView.delegate = self
        gameSessionView.locationsCollectionView.dataSource = self
        
        listenForGameUpdates()
        
#if FREE
        initializeBanner()
#endif
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameInactive), name: .gameInactive, object: nil)
    }
    
    deinit {
        // Remove any listeners
        guard let listener = listener else { return }
        listener.remove()
        NotificationCenter.default.removeObserver(self, name: .gameInactive, object: nil)
    }
    
    // MARK: - Setup UI & Listeners
    private func setupView() {
        setupButtons()
        scrollView.backgroundColor = .primaryBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .primaryBackgroundColor
        view.addSubviews(scrollView, customPopUp)
        
#if FREE
        view.addSubview(bannerView)
#endif
        
        scrollView.addSubview(gameSessionView)
        
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
        bannerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
#endif
        
    }
    
    private func setupButtons() {
        gameSessionView.endGame.touchUpInside = { [weak self] in
            guard self?.timerIsAtZero() ?? true else { return }
            FirestoreManager.deleteGame(accessCode: self?.gameData.accessCode ?? "")
        }
        gameSessionView.playAgain.touchUpInside = { [weak self] in
            DispatchQueue.main.async {
                self?.gameData.chosenPacks.shuffle()
                FirestoreManager.resetChosenLocation(with: self?.gameData.accessCode ?? "") { result in
                    self?.gameData.chosenLocation = result
                    self?.gameData.playerObjectList = []
                    self?.gameData.started = false
                    if let newGame = self?.gameData.toDictionary() {
                        FirestoreManager.setGameData(accessCode: self?.gameData.accessCode ?? "", data: newGame)
                    }
                }
            }
        }

        // Sets up the actions around the end game pop up
        customPopUp.endGamePopUpView.cancelButton.touchUpInside = { [weak self] in self?.resetViews() }
        customPopUp.endGamePopUpView.doneButton.touchUpInside = { [weak self] in
            FirestoreManager.deleteGame(accessCode: self?.gameData.accessCode ?? "")
        }
    }
    
#if FREE
    private func initializeBanner() {
        bannerView.delegate = self
        bannerView.adUnitID = Constants.IDs.gameSessionAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        os_log("Google Mobile Ads SDK version: %@", GADRequest.sdkVersion())
    }
#endif
    
    private func listenForGameUpdates() {
        listener = FirestoreManager.addListener(accessCode: gameData.accessCode) { [weak self] result in
            switch result {
            // Successfully adds listener
            case .success(let document): self?.listener(document)
            // Failure to add listener
            case .failure(let error):
                os_log("Firestore error: ",
                log: SystemLogger.shared.logger,
                type: .error,
                error.localizedDescription)                
            }
        }
    }
    
    private func listener(_ document: DocumentSnapshot) {
        // Check if game has been deleted
        if !document.exists {
            navigationController?.popToRootViewController(animated: true)
        } else {
            if let started = document.get("started") as? Bool {
                if !started {
                    navigationController?.popViewController(animated: true)
                }
            }
            if let playerList = document.get("playerList") as? [String],
                let locationList = document.get("locationList") as? [String],
                let playerObjectList = document.get("playerObjectList") as? [[String: Any]] {
                gameData.playerList = playerList
                gameData.locationList = locationList
                gameData.playerObjectList = Player.dictToPlayers(with: playerObjectList)
                self.firstPlayer = self.gameData.playerObjectList.first?.username ?? ""
                self.gameData.playerObjectList.shuffle()
                for playerObject in gameData.playerObjectList where playerObject.username == gameData.playerObject.username {
                    gameData.playerObject = playerObject
                }
                gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
                gameSessionView.userInfoView.locationLabel.text = gameData.playerObject.role == "The Spy!" ? "Figure out the location!" : String(format: "Location: %@", gameData.chosenLocation)
                updateCollectionViews()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func updateGameData() {
        gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
        gameSessionView.userInfoView.locationLabel.text = gameData.playerObject.role == "The Spy!" ? "Figure out the location!" : String(format: "Location: %@", gameData.chosenLocation)

        gameSessionView.timerLabel.text = "\(gameData.timeLimit):00"
        maxTimeInterval = TimeInterval(gameData.timeLimit * 60)  // Minutes * Seconds
                
        setupTimer()
        updateCollectionViews()
        
        gameSessionView.setNeedsUpdateConstraints()
        gameSessionView.layoutIfNeeded()
    }
    
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
        gameSessionView.playersCollectionHeight.constant = CGFloat((gameData.playerList.count + 1) / 2) * (UIElementsManager.collectionViewCellHeight + 10)
        gameSessionView.locationsCollectionHeight.constant = CGFloat((gameData.locationList.count + 1) / 2) * (UIElementsManager.collectionViewCellHeight + 10)
        gameSessionView.playersCollectionView.reloadData()
        gameSessionView.locationsCollectionView.reloadData()
        gameSessionView.playersCollectionView.setNeedsUpdateConstraints()
        gameSessionView.locationsCollectionView.setNeedsUpdateConstraints()
        gameSessionView.playersCollectionView.layoutIfNeeded()
        gameSessionView.locationsCollectionView.layoutIfNeeded()
    }
    
    // Remove current user from playerList and delete game if playerList is empty
    @objc private func gameInactive() {
        navigationController?.popToRootViewController(animated: true)
        switch gameData.playerList.count {
        case let x where x > 1:
            FirestoreManager.updateGameData(accessCode: gameData.accessCode,
                                            data: [Constants.DBStrings.playerList: FieldValue.arrayRemove([gameData.playerObject.username])])
        case 1:
            FirestoreManager.deleteGame(accessCode: gameData.accessCode)
        default: return
        }
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
            gameSessionView.timerLabel.text = string(from: currentTimeLeft)
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
    
    private func string(from timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}

// MARK: - Collection View Delegate & Data Source
extension GameSessionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case gameSessionView.playersCollectionView:
            return gameData.playerList.count
        default:
            return gameData.locationList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case gameSessionView.playersCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.playersCollectionViewCellId, for: indexPath) as? PlayersCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(username: gameData.playerList[indexPath.row], isFirstPlayer: gameData.playerList[indexPath.row] == firstPlayer)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.locationsCollectionViewCellId, for: indexPath) as? LocationsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(location: gameData.locationList[indexPath.row])
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
