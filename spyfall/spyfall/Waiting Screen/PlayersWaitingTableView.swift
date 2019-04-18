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
    func configure(username: String, isCurrentUsername: Bool) {
        pencilImage.isHidden = !isCurrentUsername
        usernameTextView.text = username
    }
}
