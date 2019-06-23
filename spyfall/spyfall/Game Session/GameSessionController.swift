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

class GameSessionController: UIViewController {

    var gameSessionView = GameSessionView()
    

//    @IBOutlet weak var usernameTableView: UITableView!
//    @IBOutlet weak var locationTableView: UITableView!
//
//    @IBOutlet weak var usernameTableHeight: NSLayoutConstraint!
//    @IBOutlet weak var locationTableHeight: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    var timer = Timer()
    var usernameList = [String]()
    var locationList = [String]()
    var playerObject = Player(role: "a role", username: "Name", votes: 0)
    var currentUsername = String()
    var accessCode = String()
    var chosenPacks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameSessionView.playersCollectionView.delegate = self
        gameSessionView.playersCollectionView.dataSource = self
        gameSessionView.locationsCollectionView.delegate = self
        gameSessionView.locationsCollectionView.dataSource = self
        
        setupView()
    }
    
    private func setupView() {
        view = gameSessionView
        db.collection("games").document(accessCode).getDocument { (document, error) in
            var gameObject = [String : Any]()
            if let document = document, document.exists {
                gameObject = (document.data())!
                print("Document data: \(gameObject))")
            } else {
                print("Document does not exist")
            }
            guard let usernameList = gameObject["playerList"],
                let playerObjectList = gameObject["playerObjectList"] as? [[String : Any]],
                let timeLimit = gameObject["timeLimit"],
                let chosenLocation = gameObject["chosenLocation"] else {
                print("Error writing document")
                return
            }

            // Store desired gameObject variables
            self.usernameList = usernameList as! [String]
            for playerObject in playerObjectList where playerObject["username"] as! String == self.currentUsername {
                self.playerObject = Player(role: playerObject["role"] as! String,
                                           username: playerObject["username"] as! String,
                                           votes: playerObject["votes"] as! Int)
            }

            self.gameSessionView.userInfoView.roleLabel.text = "Role: \(self.playerObject.role)"
            self.gameSessionView.userInfoView.locationLabel.text = "Location: \(chosenLocation)"

            self.gameSessionView.timerLabel.text = "\(timeLimit):00"
            self.setupTimer()

            for pack in self.chosenPacks {
                self.db.collection(pack).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for doc in querySnapshot!.documents { self.locationList.append(doc.documentID as String) }
                    }
//                    self.usernameTableView.reloadData()
//                    self.usernameTableView.setNeedsUpdateConstraints()
//                    self.usernameTableView.layoutIfNeeded()
//                    self.locationTableView.reloadData()
//                    self.locationTableView.setNeedsUpdateConstraints()
//                    self.locationTableView.layoutIfNeeded()
                }
            }
        }
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            var minutes: Int = Int(String(self.gameSessionView.timerLabel.text?.split(separator: ":")[0] ?? "0")) ?? 0
            var seconds: Int = Int(String(self.gameSessionView.timerLabel.text?.split(separator: ":")[1] ?? "0")) ?? 0

            seconds = seconds == 00 ? 59 : seconds - 1
            if seconds == 59 { minutes -= 1 }

            self.gameSessionView.timerLabel.text = seconds > 9 ? "\(minutes):\(seconds)" : "\(minutes):0\(seconds)"

            if self.gameSessionView.timerLabel.text == "0:00" {
                self.timer.invalidate()
            }
        })
    }
}

extension GameSessionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == gameSessionView.playersCollectionView ? (usernameList.count + 1) / 2 : locationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == usernameTableView {
//            let cellId = "usernameCell"
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsernameTableView else {
//                fatalError()
//            }
//
//            // configures the cells
//            cell.selectionStyle = .none
//            cell.configure(firstUsername: usernameList[indexPath.row * 2], secondUsername: (indexPath.row * 2) + 1 < usernameList.count - 1 ? usernameList[(indexPath.row * 2) + 1] : nil)
//            return cell
//
//        } else {
//            let cellId = "locationsCell"
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LocationsTableView else {
//                fatalError()
//            }
//
//            // configures the cells
//            cell.selectionStyle = .none
//            cell.configure(location: locationList[indexPath.row])
//            return cell
//        }
//    }
}
