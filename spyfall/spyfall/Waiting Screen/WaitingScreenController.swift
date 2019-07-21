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

class WaitingScreenController: UIViewController {
    
    let cellId: String = "playerListCell"
    
    var scrollView = UIScrollView()
    var waitingScreenView = WaitingScreenView()
    
    let db = Firestore.firestore()
    var playerObjectList = [Player]()
    var playerList = [String]()
    var currentUsername = String()
    var accessCode = String()
    var chosenPacks = [String]()
    var chosenLocation = String()
    var isStarted = false
    var segued = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingScreenView.codeLabel.text = accessCode

        waitingScreenView.startGame.addTarget(self, action: #selector(startGameWasTapped(sender:)), for: .touchUpInside)
        waitingScreenView.leaveGame.addTarget(self, action: #selector(leaveGameWasTapped(sender:)), for: .touchUpInside)

        waitingScreenView.tableView.delegate = self
        waitingScreenView.tableView.dataSource = self
        
        setupView()
        addUsernameToPlayerList()
        updatePlayerList()
        setUpKeyboard()
    }
    
    private func setupView() {
        scrollView.backgroundColor = .primaryWhite
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        waitingScreenView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .primaryWhite
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(waitingScreenView)
        waitingScreenView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        waitingScreenView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        waitingScreenView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        waitingScreenView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        //        scrollView.contentSize = waitingScreenView.bounds.size
    }
    
    // check if Start Game has been clicked
    @objc func startGameWasTapped(sender: UIButton) {
        if isStarted == true {
            return
        } else {
            // Set isStarted to true
            isStarted = true
            db.collection("games").document(accessCode).updateData(["started": true]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            var roles = [String]()
            
            db.collection(chosenPacks[0]).document(chosenLocation).getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("*", dataDescription)
                    print("Document data: \(dataDescription)")
                }
                if error != nil {
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
                self.playerObjectList.append(Player(role: "The Spy!", username: self.playerList.last!, votes: 0))
                
                for playerObject in self.playerObjectList {
                    // Add playerObjectList field to document
                    self.db.collection("games").document(self.accessCode).updateData(["playerObjectList": FieldValue.arrayUnion([[
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
    @objc func leaveGameWasTapped(sender: UIButton) {
        playerList = playerList.filter { $0 != currentUsername }
        db.collection("games").document(accessCode).updateData(["playerList": playerList])
        if playerList.isEmpty { db.collection("games").document(accessCode).delete()}
        present(HomeController(), animated: false, completion: nil)
    }
    
    //     adds players username to firestore
    func addUsernameToPlayerList() {
        db.collection("games").document(accessCode).updateData(["playerList": FieldValue.arrayUnion([currentUsername])]) { err in
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
                    let isStartedData = document.get("started"),
                    let chosenPacksData = document.get("chosenPacks"),
                    let chosenLocationData = document.get("chosenLocation") else {
                        print("Document data was empty.")
                        return
                }
                
                // update playerList and tableView
                if let playerList = playerListData as? [String],
                    let isStarted = isStartedData as? Bool,
                    let chosenPacks = chosenPacksData as? [String],
                    let chosenLocation = chosenLocationData as? String {
                    self.playerList = playerList
                    self.isStarted = isStarted
                    self.chosenPacks = chosenPacks
                    self.chosenLocation = chosenLocation
                }

                self.waitingScreenView.tableHeight.constant = CGFloat(self.playerList.count) * UIElementSizes.tableViewCellHeight
                self.waitingScreenView.tableView.reloadData()
                self.waitingScreenView.tableView.setNeedsUpdateConstraints()
                self.waitingScreenView.tableView.layoutIfNeeded()
                
                // Check for segue
                if let playerObjects = document.get("playerObjectList") as? [[String: Any]] {
                    if playerObjects.last?["role"] as? String == "The Spy!" && !self.segued {
                            self.segueToGameSessionController()
                    }
                }
        }
    }
    
    private func segueToGameSessionController() {
        segued.toggle()
        let nextScreen = GameSessionController()
        nextScreen.currentUsername = currentUsername
        nextScreen.accessCode = self.accessCode
        nextScreen.chosenPacks = self.chosenPacks
        present(nextScreen, animated: true, completion: nil)
    }

    func setUpKeyboard() {
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        // updates the tableView cells to new username
        NotificationCenter.default.post(name: .editingOver, object: nil)
        waitingScreenView.tableView.reloadData()
    }
}

// MARK: - Table View Delegate & Data Source
extension WaitingScreenController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isUser = Bool()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: waitingScreenView.cellId) as? PlayersWaitingTableViewCell else {
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

}
