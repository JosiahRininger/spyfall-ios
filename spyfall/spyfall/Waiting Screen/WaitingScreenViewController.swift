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
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    let db = Firestore.firestore()
    let cellIdentifier = "waitingPlayersCell"
    var playerList = [String]()
    var currentUsername: String?
    var accessCode: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        addUsernameToPlayerList()
        updatePlayerList()
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
                print("Current data: \(data)")
                self.tableView.reloadData()
        }
    }
    
    //        let db = Firestore.firestore()
    //        let docRef = db.collection("games").document(accessCode!)
    //
    //        docRef.getDocument(source: .cache) { (document, error) in
    //            if let document = document {
    //                let playerList = document.get("playerList")
    //            } else {
    //                print("Document does not exist in cache")
    //            }
    //        }
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
        isUser = playerList[indexPath.row] == currentUsername
        cell.configure(username: (playerList[indexPath.row]), isCurrentUsername: isUser)
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight?.constant = self.tableView.contentSize.height
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}
