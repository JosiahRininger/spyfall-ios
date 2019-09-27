//
//  LocationsTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class LocationsCollectionViewCell: UICollectionViewCell {
    
    let locationLabel = UIElementsManager.createLabel(with: "", fontSize: 16)

    var isTapped: Bool = false {
        didSet {
            switch self.isTapped {
            case true:
                locationLabel.attributedText = NSAttributedString(string: locationLabel.attributedText?.string ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                locationLabel.textColor = .secondaryGray
            case false:
                locationLabel.attributedText = NSAttributedString(string: locationLabel.attributedText?.string ?? "", attributes: .none)
                locationLabel.textColor = .mainText
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
