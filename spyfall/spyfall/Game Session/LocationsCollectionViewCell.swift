//
//  LocationsTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class LocationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    
    func configure(location: String) {
        locationLabel.text = location
    }

}
