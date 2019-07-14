//
//  usernameTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class UsernameCollectionViewCell: UICollectionViewCell {
    
    let usernameLabel = UIElementsManager.createGenericLabel(with: "", fontSize: 16)
    
    var isTapped: Bool = false {
        didSet {
            setNeedsDisplay()
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
        backgroundColor = .cellGray
        layer.cornerRadius = 9
        
        addSubview(usernameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
    }
    
    func configure(username: String) {
        usernameLabel.text = username
    }
    
}
