//
//  PlayersWaitingTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/16/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class PlayersWaitingTableView: UITableViewCell {
    
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var usernameTextView: UITextField!
    @IBOutlet weak var pencilImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // configures text for table view cells
    func configure(username: String, index: Int, isCurrentUsername: Bool) -> String {
        playerNumber.text = String(index)
        pencilImage.isHidden = true
        pencilImage.isUserInteractionEnabled = false
        if isCurrentUsername {
            if usernameTextView.text == "" { usernameTextView.text = username }
            pencilImage.isHidden = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeUsername))
            pencilImage.addGestureRecognizer(tapGesture)
            pencilImage.isUserInteractionEnabled = true
            NotificationCenter.default.addObserver(self, selector: #selector(disableUsernameInteraction), name: NSNotification.Name("editingOver"), object: nil)
            return usernameTextView.text!
        } else {
            usernameTextView.text = username
            return username
        }
    }
    
    @objc func changeUsername() {
        usernameTextView.isUserInteractionEnabled = true
        usernameTextView.becomeFirstResponder()
    }
    
    @objc func disableUsernameInteraction() {
        usernameTextView.isUserInteractionEnabled = false
    }
}
