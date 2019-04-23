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
    var playerList = [String]()
    var currentUsername: String?
    var accessCode: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCodeLabel.text = accessCode!

        startGame.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        startGame.layer.borderWidth = 1
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
    
    @IBAction func startGameAction(_ sender: Any) {
        
    }
    
    @objc func leaveGameActionOnClick(sender: UIButton) {
        let rowToDelete = IndexPath(row: playerList.firstIndex(of: currentUsername!)!, section: 0)
        tableView.deleteRows(at: [rowToDelete], with: UITableView.RowAnimation.automatic)
        playerList = playerList.filter() { $0 != currentUsername }
        db.collection("games").document(accessCode!).updateData(["playerList": playerList])
    }
    
    func addUsernameToPlayerList() {
        db.collection("games").document(accessCode!).updateData(["playerList" : FieldValue.arrayUnion([currentUsername!])]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updatePlayerList() {
        db.collection("games").document(accessCode!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.get("playerList") else {
                    print("Document data was empty.")
                    return
                }
                
                // update playerList and tableView
                self.playerList = data as! [String]
                self.tableView.reloadData()
                self.tableView.setNeedsUpdateConstraints()
                self.tableView.layoutIfNeeded()
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
            db.collection("games").document(accessCode!).updateData(["playerList": playerList])
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if
//    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.tableView.contentSize.height
    }
}
