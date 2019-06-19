//
//  JoinGameView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/18/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class JoinGameView: UIView {
    
    var welcomeLabel = UIElementsManager.createHeaderLabel(with: "Welcome to Spyfall")
    
    var topLine = UIElementsManager.createLineView()
    
    var accessCodeTextField = UIElementsManager.createGenericTextField(with: "Enter an access code")
    
    var usernameTextField = UIElementsManager.createGenericTextField(with: "Enter a username")
    
    var bottomLine = UIElementsManager.createLineView()
    
    var join = UIElementsManager.createGenericButton(with: "JOIN")
    
    var back = UIElementsManager.createGenericButton(with: "BACK")
    
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
        backgroundColor = .white
        
        addSubview(welcomeLabel)
        addSubview(topLine)
        addSubview(accessCodeTextField)
        addSubview(usernameTextField)
        addSubview(bottomLine)
        addSubview(join)
        addSubview(back)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            accessCodeTextField.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            accessCodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            accessCodeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            usernameTextField.topAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            accessCodeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            bottomLine.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            topLine.bottomAnchor.constraint(equalTo: accessCodeTextField.topAnchor, constant: -30),
            topLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            topLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            welcomeLabel.bottomAnchor.constraint(equalTo: topLine.topAnchor, constant: -60),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            join.topAnchor.constraint(equalTo: bottomLine.bottomAnchor),
            join.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5),
            
            back.topAnchor.constraint(equalTo: bottomLine.bottomAnchor),
            back.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5)
            ])
    }
    
}

