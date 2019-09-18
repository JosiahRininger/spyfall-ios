//
//  GameSessionViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

final class GameSessionController: UIViewController {

    var scrollView = UIScrollView()
    var gameSessionView = GameSessionView()
    var customPopUp = EndGamePopUpView()
    
    var timer = Timer()
    var timeLimit = String()
    var usernameList = [String]()
    var locationList = [String]()
    var playerObject = Player(role: "a role", username: "Name", votes: 0)
    var currentUsername = String()
    var accessCode = String()
    var chosenPacks = [String]()
    var firstPlayer = String()
    private var currentTimeLeft: TimeInterval = 0
    private var maxTimeInterval: TimeInterval = TimeInterval()
    private var startDate: Date?
    
    var gameData = GameData(playerObject: Player(role: String(), username: String(), votes: Int()), usernameList: [String](), timeLimit: Int(), chosenLocation: String(), locationList: [String()]) {
        didSet {
                NotificationCenter.default.post(name: .gameDataRetrieved, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameSessionView.playersCollectionView.delegate = self
        gameSessionView.playersCollectionView.dataSource = self
        gameSessionView.locationsCollectionView.delegate = self
        gameSessionView.locationsCollectionView.dataSource = self
        
        callNetworkManager()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGame), name: .gameDataRetrieved, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func callNetworkManager() {
        FirestoreManager.retrieveGameData(accessCode: self.accessCode, currentUsername: self.currentUsername, chosenPacks: self.chosenPacks) { result in
            self.gameData = result
        }
    }
    
    private func setupView() {
        scrollView.backgroundColor = .primaryWhite
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        gameSessionView.translatesAutoresizingMaskIntoConstraints = false
        gameSessionView.playAgain.isHidden = true
        
        view.backgroundColor = .primaryWhite
        view.addSubviews(scrollView, customPopUp)
        scrollView.addSubview(gameSessionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            gameSessionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            gameSessionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            gameSessionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            gameSessionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        gameSessionView.endGame.touchUpInside = { [weak self] in self?.endGameWasTapped() }
        gameSessionView.playAgain.touchUpInside = { [weak self] in self?.playAgainWasTapped() }

        // Sets up the actions around the end game pop up
        customPopUp.endGamePopUpView.cancelButton.touchUpInside = { [weak self] in self?.resetViews() }
        customPopUp.endGamePopUpView.doneButton.touchUpInside = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func updateGame() {
        usernameList = gameData.usernameList
        locationList = gameData.locationList
        
        gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
        gameSessionView.userInfoView.locationLabel.text = gameData.playerObject.role == "The Spy!" ? "Figure out the location!" : String(format: "GameSessionLocation", gameData.chosenLocation)

        gameSessionView.timerLabel.text = "\(gameData.timeLimit):00"
        maxTimeInterval = TimeInterval(gameData.timeLimit * 60)  // Minutes * Seconds
        
        firstPlayer = usernameList.randomElement() ?? ""
        
        setupTimer()
        updateCollectionViews()
        
        gameSessionView.setNeedsUpdateConstraints()
        gameSessionView.layoutIfNeeded()
    }
    
    @objc func endGameWasTapped() {
        guard timerIsDone() else { return }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func playAgainWasTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func timerIsDone() -> Bool {
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

    var t = 0.0
    var c = 0
    private func string(from timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        if t == timeInterval {
            c += 1
        } else {
            t = timeInterval
            c = 0
        }
        print("T:", String(timeInterval))
        print("C:", String(c))
        return String(format: "%01d:%02d", minutes, seconds)
    }

    private func setupTimer() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateGameSessionView()
        }
    }

    private func updateGameSessionView() {
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
            gameEnded()
        default:
            gameSessionView.timerLabel.text = string(from: currentTimeLeft)
        }
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
    
    private func gameEnded() {
        gameSessionView.endGameTopAnchor.constant = UIElementSizes.buttonHeight + 48
        gameSessionView.playAgain.isHidden = false
    }
    
    private func updateCollectionViews() {
        gameSessionView.playersCollectionHeight.constant = CGFloat((usernameList.count + 1) / 2) * (UIElementSizes.collectionViewCellHeight + 10)
        gameSessionView.locationsCollectionHeight.constant = CGFloat((locationList.count + 1) / 2) * (UIElementSizes.collectionViewCellHeight + 10)
        gameSessionView.playersCollectionView.reloadData()
        gameSessionView.locationsCollectionView.reloadData()
        gameSessionView.playersCollectionView.setNeedsUpdateConstraints()
        gameSessionView.locationsCollectionView.setNeedsUpdateConstraints()
        gameSessionView.playersCollectionView.layoutIfNeeded()
        gameSessionView.locationsCollectionView.layoutIfNeeded()
    }
    
}

// MARK: - Collection View Delegate & Data Source
extension GameSessionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case gameSessionView.playersCollectionView:
            return usernameList.count
        default:
            return locationList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case gameSessionView.playersCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.playersCollectionViewCellId, for: indexPath) as? PlayersCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(username: usernameList[indexPath.row], isFirstPlayer: usernameList[indexPath.row] == firstPlayer)
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
        return CGSize(width: (collectionView.frame.size.width - 14) / 2, height: UIElementSizes.collectionViewCellHeight)
    }
}
