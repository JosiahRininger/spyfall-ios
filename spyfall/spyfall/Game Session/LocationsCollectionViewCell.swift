//
//  LocationsTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class LocationsCollectionViewCell: UICollectionViewCell {
    
    let locationLabel = UIElementsManager.createGenericLabel(with: "", fontSize: 16)

    var isTapped: Bool = false {
        didSet {
            switch self.isTapped {
            case true:
                print("flip")
            //                usernameLabel.attributedText
            case false:
                print("flop")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        backgroundColor = .cellGray
        layer.cornerRadius = 9
        
        addSubview(locationLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
    }
    
    func configure(location: String) {
        locationLabel.text = location
    }

}