//
//  usernameTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class UsernameTableView: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstUsername: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(firstUsername: String, secondUsername: String?) {
        self.firstUsername.text = firstUsername
        if let username = secondUsername {
            self.secondUsername.text = username
        } else {
            self.secondUsername.isHidden = true
            self.secondView.isHidden = true
        }
    }

}
