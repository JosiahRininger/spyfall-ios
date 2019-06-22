//
//  WaitingScreenView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/19/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class WaitingScreenView: UIView {
    
    var welcomeLabel = UIElementsManager.createHeaderLabel(with: "Welcome to Spyfall", fontSize: 81)
    
    var accessCodeLabel = UIElementsManager.createHeaderLabel(with: "access code", fontSize: 19)
    
    var codeLabel = UIElementsManager.createGenericLabel(with: "", fontSize: 18)
    
    var topLine = UIElementsManager.createLineView()
    
    var bottomLine = UIElementsManager.createLineView()
    
    var startGame = UIElementsManager.createGenericButton(with: "START GAME")
    
    var leaveGame = UIElementsManager.createGenericButton(with: "LEAVE GAME")
    
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
        
        addSubviews(welcomeLabel, accessCodeLabel, codeLabel, topLine, bottomLine, startGame, leaveGame)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
//            bottomLine.topAnchor.constraint(equalTo: timeLimitTextField.bottomAnchor, constant: 30),
//            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
//            
//            create.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 30),
//            create.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5),
//            
//            back.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 30),
//            back.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5),
//            
//            locationsLabel.bottomAnchor.constraint(equalTo: packOneCheckBox.topAnchor, constant: -20),
//            locationsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            
//            nameTextField.bottomAnchor.constraint(equalTo: locationsLabel.topAnchor, constant: -30),
//            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
//            
//            topLine.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -30),
//            topLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            topLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
//            
//            welcomeLabel.bottomAnchor.constraint(equalTo: topLine.topAnchor, constant: -30),
//            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
        ])
    }
    
}
