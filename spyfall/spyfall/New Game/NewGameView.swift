//
//  NewGameView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/18/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class NewGameView: UIView {
    
    let timeRange: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var newGameLabel = UIElementsManager.createLabel(with: "New Game", fontSize: 40, isHeader: true)
    
    var usernameLabel = UIElementsManager.createLabel(with: "Enter a username:", fontSize: 24, isHeader: true)
    var usernameTextField = UIElementsManager.createTextField(with: "Username")
    
    var choosePacksLabel = UIElementsManager.createLabel(with: "Choose packs:", fontSize: 24, isHeader: true)
    
    var packOneView = UIElementsManager.createPackView(packColor: .packOneColor, packNumberString: "1", packName: "Standard\nPack")
    var packTwoView = UIElementsManager.createPackView(packColor: .packTwoColor, packNumberString: "2", packName: "Standard\nPack")
    var specialPackView = UIElementsManager.createPackView(packColor: .specialPackColor, packNumberString: "1", packName: "Special\nPack")
    
    var timeLabel = UIElementsManager.createLabel(with: "Pick a time limit:", fontSize: 24, isHeader: true)
    var disclaimerLabel = UIElementsManager.createLabel(with: "Time limits must be 10 minutes or less", fontSize: 13)
    
    var timeLimitTextField = UIElementsManager.createNumberTextField()
    
    var back = UIElementsManager.createButton(with: "Back", color: .white)
    var create = UIElementsManager.createButton(with: "Create")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementSizes.windowWidth, height: UIElementSizes.windowHeight)
        backgroundColor = .primaryWhite
        
        addSubviews(newGameLabel, usernameLabel, usernameTextField, choosePacksLabel, packOneView, packTwoView, specialPackView, timeLimitTextField, timeLabel, disclaimerLabel, back, create)

        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            newGameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            newGameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            usernameLabel.topAnchor.constraint(equalTo: newGameLabel.bottomAnchor, constant: 30),
            usernameLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -14),
            
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            choosePacksLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            choosePacksLabel.topAnchor.constraint(lessThanOrEqualTo: usernameTextField.bottomAnchor, constant: 70),
            choosePacksLabel.bottomAnchor.constraint(equalTo: packTwoView.topAnchor, constant: -14),
            
            packTwoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            packTwoView.leadingAnchor.constraint(lessThanOrEqualTo: packOneView.trailingAnchor, constant: 50),
            packTwoView.trailingAnchor.constraint(greaterThanOrEqualTo: specialPackView.leadingAnchor, constant: -50),
            packTwoView.bottomAnchor.constraint(greaterThanOrEqualTo: timeLimitTextField.topAnchor, constant: -70),
            
            packOneView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            packOneView.centerYAnchor.constraint(equalTo: packTwoView.centerYAnchor),
            
            specialPackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            specialPackView.centerYAnchor.constraint(equalTo: packTwoView.centerYAnchor),
            
            timeLimitTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            timeLimitTextField.bottomAnchor.constraint(greaterThanOrEqualTo: back.topAnchor, constant: -70),
            
            timeLabel.topAnchor.constraint(equalTo: timeLimitTextField.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            
            disclaimerLabel.bottomAnchor.constraint(equalTo: timeLimitTextField.bottomAnchor),
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            
            create.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -87),
            create.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            create.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            back.bottomAnchor.constraint(equalTo: create.topAnchor, constant: -24),
            back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            back.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding)
            ])
    }

}
