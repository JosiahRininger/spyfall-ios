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
    var firstPlayer = String()
    
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
        scrollView.backgroundColor = .primaryWhite
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        gameSessionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .primaryWhite
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(gameSessionView)
        gameSessionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        gameSessionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        gameSessionView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        gameSessionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
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
        
        gameSessionView.playersCollectionHeight.constant = CGFloat((usernameList.count + 1) / 2) * (UIElementSizes.collectionViewCellHeight + 10)
        gameSessionView.locationsCollectionHeight.constant = CGFloat((locationList.count + 1) / 2) * (UIElementSizes.collectionViewCellHeight + 10)
        gameSessionView.playersCollectionView.reloadData()
        gameSessionView.locationsCollectionView.reloadData()
        gameSessionView.playersCollectionView.setNeedsUpdateConstraints()
        gameSessionView.locationsCollectionView.setNeedsUpdateConstraints()
        gameSessionView.playersCollectionView.layoutIfNeeded()
        gameSessionView.locationsCollectionView.layoutIfNeeded()
        gameSessionView.setNeedsUpdateConstraints()
        gameSessionView.layoutIfNeeded()
        print(scrollView.bounds.height, gameSessionView.bounds.height)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameSessionView.playersCollectionViewCellId, for: indexPath) as? PlayersCollectionViewCell else { return UICollectionViewCell() }
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
            let cell = gameSessionView.playersCollectionView.cellForItem(at: indexPath) as? LocationsCollectionViewCell
            cell?.isTapped.toggle()
            
        }
    }

}

extension GameSessionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - (7 * 2)) / 2, height: UIElementSizes.collectionViewCellHeight)
    }
}