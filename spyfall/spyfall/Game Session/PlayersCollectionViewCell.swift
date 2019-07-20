//
//  usernameTableView.swift
//  spyfall
//
//  Created by Josiah Rininger on 5/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class PlayersCollectionViewCell: UICollectionViewCell {
    
    let usernameLabel = UIElementsManager.createGenericLabel(with: "", fontSize: 16)
    
    var firstView: UIView = {
        var v = UIElementsManager.createCircleView()
        var i = UIElementsManager.createHeaderLabel(with: "1st", fontSize: 11, color: .primaryWhite)
        v.addSubview(i)
        i.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        i.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        return v
    }()
    
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
        
        addSubviews(usernameLabel, firstView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            firstView.centerYAnchor.constraint(equalTo: topAnchor, constant: 5),
            firstView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1)
            ])
        
    }
    
    func configure(username: String, isFirstPlayer: Bool) {
        usernameLabel.attributedText = NSAttributedString(string: username)
        firstView.isHidden = !isFirstPlayer
    }
    
}
