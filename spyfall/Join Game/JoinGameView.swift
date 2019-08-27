//
//  JoinGameView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/18/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class JoinGameView: UIView {
    
    var joinGameLabel = UIElementsManager.createLabel(with: "Join Game", fontSize: 40, isHeader: true)

    var usernameLabel = UIElementsManager.createLabel(with: "Enter a username:", fontSize: 24, isHeader: true)
    var usernameTextField = UIElementsManager.createTextField(with: "Username")
    
    var accessCodeLabel = UIElementsManager.createLabel(with: "Enter an access code:", fontSize: 24, isHeader: true)
    var accessCodeTextField = UIElementsManager.createTextField(with: "Access code")
    
    var back = UIElementsManager.createButton(with: "Back", color: .white)
    var join = UIElementsManager.createButton(with: "Join")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight)
        backgroundColor = .primaryWhite
        
        addSubviews(joinGameLabel, usernameLabel, usernameTextField, accessCodeLabel, accessCodeTextField, join, back)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            joinGameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            joinGameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            usernameLabel.topAnchor.constraint(equalTo: joinGameLabel.bottomAnchor, constant: 30),
            usernameLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -14),
            
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            usernameTextField.bottomAnchor.constraint(equalTo: accessCodeLabel.topAnchor, constant: -14),
            
            accessCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            accessCodeLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            accessCodeLabel.bottomAnchor.constraint(equalTo: accessCodeTextField.topAnchor, constant: -14),
            
            accessCodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            accessCodeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            accessCodeTextField.bottomAnchor.constraint(equalTo: back.topAnchor, constant: -14),

            back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            back.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            back.bottomAnchor.constraint(equalTo: join.topAnchor, constant: -24),

            join.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            join.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding)
            ])
    }
    
}
