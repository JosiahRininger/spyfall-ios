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
    private let maxTimeInterval: TimeInterval = 10 * 60 // Minutes * Seconds
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
        
        gameSessionView.endGame.addTarget(self, action: #selector(endGameWasTapped), for: .touchUpInside)
        
        setupView()
        callNetworkManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGame), name: .gameDataRetrieved, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func callNetworkManager() {
        FirebaseManager.retrieveGameData(accessCode: self.accessCode, currentUsername: self.currentUsername, chosenPacks: self.chosenPacks) { result in
            self.gameData = result
        }
    }
    
    private func setupView() {
        scrollView.backgroundColor = .primaryWhite
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        gameSessionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .primaryWhite
        view.addSubview(scrollView)
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
//        scrollView.contentSize = gameSessionView.bounds.size
    }
    
    @objc func updateGame() {
        usernameList = gameData.usernameList
        locationList = gameData.locationList
        
        gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
        gameSessionView.userInfoView.locationLabel.text = gameData.playerObject.role == "The Spy!" ? "Figure out the location!" : "Location: \(gameData.chosenLocation)"
        gameSessionView.timerLabel.text = "\(gameData.timeLimit):00"
        
        firstPlayer = usernameList.randomElement() ?? ""
        
        setupTimer()
        updateCollectionViews()
        
        gameSessionView.setNeedsUpdateConstraints()
        gameSessionView.layoutIfNeeded()
        print(scrollView.bounds.height, gameSessionView.bounds.height)
    }
    
    @objc func endGameWasTapped() {
        if !timerIsDone() { return }
        
        present(HomeController(), animated: false, completion: nil)
    }
    
    func timerIsDone() -> Bool {
        let alert = CreateAlertController().with(title: "",
                                                 message: nil,
                                                 actions: UIAlertAction(title: "Yes", style: .default, handler: { _ in
                                                    self.present(HomeController(), animated: false, completion: nil)
                                                 }),
                                                 UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if gameSessionView.timerLabel.text != "0:00" {
            alert.title = "Are you sure you want to end the game?"
        } else {
            return true
        }
        self.present(alert, animated: true, completion: nil)
        return false
    }

    private func string(fromTime interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
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
        currentTimeLeft = max(0, maxTimeInterval - interval)

        if currentTimeLeft == 0 {
            gameSessionView.timerLabel.text = "0:00"
            timer.invalidate()
            self.startDate = nil
        } else {
            gameSessionView.timerLabel.text = string(fromTime: currentTimeLeft)
        }
    }
    
    func updateCollectionViews() {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameSessionView.locationsCollectionViewCellId, for: indexPath) as? LocationsCollectionViewCell else { return UICollectionViewCell() }
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
