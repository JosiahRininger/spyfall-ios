//
//  WaitingScreenTableTableViewController.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class WaitingScreenTableViewController: UITableViewController {

    let cellIdentifier = "waitingPlayersCell"
    var playerList = [String]()
    var currentUsername: String?
    var accessCode: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        playerList = ["yes", "you", "did", "it"]
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    func updatePlayerList() {
        /*
        let db = Firestore.firestore()
        db.collection("games").document(accessCode).updateData(["playerList" : FieldValue.arrayUnion([currentUsername])]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }*/
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1
        case 1: return playerList.count
        case 2: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "waitingPlayersCell"
        var isUser = Bool()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PlayersWaitingTableView else {
            fatalError()
        }
        isUser = playerList[indexPath.row] == currentUsername
        cell.configure(username: (playerList[indexPath.row]), isCurrentUsername: isUser)
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
