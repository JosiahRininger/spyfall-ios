//
//  WaitingScreenViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class WaitingScreenViewController: UIViewController {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var leaveGame: UIButton!
    @IBOutlet weak var accessCodeLabel: UILabel!
    
    let db = Firestore.firestore()
    let cellIdentifier = "waitingPlayersCell"
    var playerObjectList = [Player]()
    var playerList = [String]()
    var currentUsername = String()
    var accessCode = String()
    var chosenPacks = [String]()
    var chosenLocation = String()
    var isStarted = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCodeLabel.text = accessCode
        
        startGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        startGame.layer.borderWidth = 1
        startGame.addTarget(self, action: #selector(startGameActionOnClick(sender:)), for: .touchUpInside)
        leaveGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        leaveGame.layer.borderWidth = 1
        leaveGame.addTarget(self, action: #selector(leaveGameActionOnClick(sender:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        addUsernameToPlayerList()
        updatePlayerList()
        setUpKeyboard()
    }
    
    // check if Start Game has been clicked
    @objc func startGameActionOnClick(sender: UIButton) {
        if isStarted == true {
            print("* hmmmm")
            return
        } else {
            // Set isStarted to true
            isStarted = true
            db.collection("games").document(accessCode).updateData(["isStarted" : true]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            var roles = [String]()
            
            db.collection(chosenPacks[0]).document(chosenLocation).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("*", dataDescription)
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
                print("*", document?["roles"] ?? "0")
                guard let rolesList = document?["roles"] as? [String] else {
                    print("Error writing document")
                    return
                }
                
                // Assigns each player a role
                roles = rolesList
                self.playerList.shuffle()
                roles.shuffle()
                for i in 0..<(self.playerList.count - 1) {
                    self.playerObjectList.append(Player(role: roles[i], username: self.playerList[i], votes: 0))
                }
                self.playerObjectList.append(Player(role: "the Spy!", username: self.playerList.last!, votes: 0))
                
                for playerObject in self.playerObjectList {
                    // Add playerObjectList field to document
                    self.db.collection("games").document(self.accessCode).updateData(["playerObjectList" : FieldValue.arrayUnion([[
                        "role": playerObject.role,
                        "username": playerObject.username,
                        "votes": playerObject.votes
                        ]])]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                    }
                }
                
            }
        }
    }
    
    //     deletes player from game and deletes game if playerList is empty
    @objc func leaveGameActionOnClick(sender: UIButton) {
        playerList = playerList.filter() { $0 != currentUsername }
        db.collection("games").document(accessCode).updateData(["playerList": playerList])
        if playerList.isEmpty { db.collection("games").document(accessCode).delete()}
        tableView.reloadData()
    }
    
    //     adds players username to firestore
    func addUsernameToPlayerList() {
        db.collection("games").document(accessCode).updateData(["playerList" : FieldValue.arrayUnion([currentUsername])]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    // listenor that updates playerList and tableView when firestore playerList is updated
    func updatePlayerList() {
        db.collection("games").document(accessCode)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let playerListData = document.get("playerList"),
                    let isStartedData = document.get("isStarted"),
                    let chosenPacksData = document.get("chosenPacks"),
                    let chosenLocationData = document.get("chosenLocation") else {
                        print("Document data was empty.")
                        return
                }
                
                // update playerList and tableView
                self.playerList = playerListData as! [String]
                self.isStarted = isStartedData as! Bool
                self.chosenPacks = chosenPacksData as! [String]
                self.chosenLocation = chosenLocationData as! String
                self.tableView.reloadData()
                self.tableView.setNeedsUpdateConstraints()
                self.tableView.layoutIfNeeded()
                
                // Check for segue
                if let playerObjects = document.get("playerObjectList") as? [[String : Any]] {
                    if playerObjects.last?["role"] as? String == "the Spy!" {
                        self.performSegue(withIdentifier: "gameSessionSegue", sender: nil)
                    }
                }
        }
    }
    
    // Segues the username and
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSessionSegue" {
            guard let dest = segue.destination as? GameSessionViewController else {
                fatalError()
            }
            dest.currentUsername = self.currentUsername
            dest.accessCode = self.accessCode
            dest.chosenPacks = self.chosenPacks
        }
    }
    
    func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        // updates the tableView cells to new username
        NotificationCenter.default.post(name: NSNotification.Name("editingOver"), object: nil)
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate & Data Source
extension WaitingScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "waitingPlayersCell"
        var isUser = Bool()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PlayersWaitingTableView else {
            fatalError()
        }
        
        // configures the cells
        cell.selectionStyle = .none
        isUser = playerList[indexPath.row] == currentUsername
        let editedUsername = cell.configure(username: (playerList[indexPath.row]), index: indexPath.row + 1, isCurrentUsername: isUser)
        
        // updates playerList when player changes name
        if editedUsername != currentUsername && isUser {
            currentUsername = editedUsername
            playerList[indexPath.row] = editedUsername
            db.collection("games").document(accessCode).updateData(["playerList": playerList])
        }
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.tableView.contentSize.height
    }
}
