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

class GameSessionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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
    
    var gameData = GameData(playerObject: Player(role: String(), username: String(), votes: Int()), usernameList: [String](), timeLimit: Int(), chosenLocation: String(), locationList: [String()]) {
        didSet {
                NotificationCenter.default.post(name: .gameDataRetrieved, object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        NetworkManager.retrieveGameData(accessCode: self.accessCode, currentUsername: self.currentUsername, chosenPacks: self.chosenPacks) { result in
            self.gameData = result
        }
    }
    
    private func setupView() {
        gameSessionView.playersCollectionView.delegate = self
        gameSessionView.playersCollectionView.dataSource = self
        gameSessionView.locationsCollectionView.delegate = self
        gameSessionView.locationsCollectionView.dataSource = self
        
//        scrollView.frame = CGRect(x: 0, y: 0, width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight)
        scrollView.backgroundColor = .primaryWhite
//        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .primaryWhite
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(gameSessionView)
        gameSessionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollView.contentSize = gameSessionView.bounds.size
    }
    
    @objc func updateGame() {
        usernameList = gameData.usernameList
        locationList = gameData.locationList
        gameSessionView.userInfoView.roleLabel.text = "Role: \(gameData.playerObject.role)"
        gameSessionView.userInfoView.locationLabel.text = "Location: \(gameData.chosenLocation)"
        gameSessionView.timerLabel.text = "\(gameData.timeLimit):00"
        
        setupTimer()
        
        gameSessionView.playersCollectionHeight.constant = CGFloat(usernameList.count) * UIElementSizes.collectionViewCellHeight
        gameSessionView.locationsCollectionHeight.constant = CGFloat(locationList.count) * UIElementSizes.collectionViewCellHeight
        gameSessionView.playersCollectionView.reloadData()
        gameSessionView.locationsCollectionView.reloadData()
        gameSessionView.playersCollectionView.setNeedsUpdateConstraints()
        gameSessionView.locationsCollectionView.setNeedsUpdateConstraints()
        gameSessionView.playersCollectionView.layoutIfNeeded()
        gameSessionView.locationsCollectionView.layoutIfNeeded()
        gameSessionView.setNeedsUpdateConstraints()
        gameSessionView.layoutIfNeeded()
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            var minutes: Int = Int(String(self.gameSessionView.timerLabel.text?.split(separator: ":")[0] ?? "0")) ?? 0
            var seconds: Int = Int(String(self.gameSessionView.timerLabel.text?.split(separator: ":")[1] ?? "0")) ?? 0

            seconds = seconds == 0 ? 59 : seconds - 1
            if seconds == 59 { minutes -= 1 }

            self.gameSessionView.timerLabel.text = seconds > 9 ? "\(minutes):\(seconds)" : "\(minutes):0\(seconds)"

            if self.gameSessionView.timerLabel.text == "0:00" {
                self.timer.invalidate()
            }
        })
    }
    
}

private typealias CollectionViewDelegateAndProtocols = GameSessionController
extension CollectionViewDelegateAndProtocols {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == gameSessionView.playersCollectionView ? usernameList.count : locationList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gameSessionView.playersCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameSessionView.playersCollectionViewCellId, for: indexPath) as? UsernameCollectionViewCell else {
                fatalError()
            }

            // configures the cells
            cell.configure(username: usernameList[indexPath.row])

            return cell

        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameSessionView.locationsCollectionViewCellId, for: indexPath) as? LocationsCollectionViewCell else {
                fatalError()
            }

            // configures the cells
            cell.configure(location: locationList[indexPath.row])

            return cell
        }
    }

}

extension GameSessionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIElementSizes.windowWidth - 8, height: UIElementSizes.collectionViewCellHeight)
    }
}
