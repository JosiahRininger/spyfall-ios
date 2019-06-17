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

class GameSessionViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hideLabel: UILabel!
    @IBOutlet weak var leaveGame: UIButton!
    
    @IBOutlet weak var usernameTableView: UITableView!
    @IBOutlet weak var locationTableView: UITableView!

    let db = Firestore.firestore()
    var usernameList = [String]()
    var locationList = [String]()
    var playerObject = Player(role: "a role", username: "Name", votes: 0)
    var currentUsername = String()
    var accessCode = String()
    var chosenPacks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaveGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        leaveGame.layer.borderWidth = 1
        
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        usernameTableView.isScrollEnabled = false
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.isScrollEnabled = false
        
        setupView()
    }
    
    private func setupView() {
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
            
            self.timerLabel.text = "\(timeLimit):00"
            self.roleLabel.text = "You are \(self.playerObject.role)"
            self.locationLabel.text = "at \(chosenLocation)"
            
            for pack in self.chosenPacks {
                self.db.collection(pack).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for doc in querySnapshot!.documents { self.locationList.append(doc.documentID as String) }
                    }
                    self.usernameTableView.reloadData()
                    self.locationTableView.reloadData()
                }
            }
        }
    }
}

extension GameSessionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == usernameTableView ? (usernameList.count + 1) / 2 : locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == usernameTableView {
            let cellId = "usernameCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsernameTableView else {
                fatalError()
            }
            
            // configures the cells
            cell.selectionStyle = .none
            cell.configure(firstUsername: usernameList[indexPath.row * 2], secondUsername: (indexPath.row * 2) + 1 < usernameList.count - 1 ? usernameList[(indexPath.row * 2) + 1] : nil)
            return cell
            
        } else {
            let cellId = "locationsCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LocationsTableView else {
                fatalError()
            }
            
            // configures the cells
            cell.selectionStyle = .none
            cell.configure(location: locationList[indexPath.row])
            return cell
        }
    }
}
