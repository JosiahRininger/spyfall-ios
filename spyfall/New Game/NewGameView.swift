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
    
    var newGameLabel = UIElementsManager.createLabel(with: "New Game", fontSize: 40, textAlignment: .center, isHeader: true)
    
    var newGameStackView = UIElementsManager.createStackView(axis: .vertical)
    var usernameView = UIElementsManager.createView(isUserInteractionEnabled: true)
    var packView = UIElementsManager.createView(isUserInteractionEnabled: true)
    var timeView = UIElementsManager.createView(isUserInteractionEnabled: true)
    
    var usernameLabel = UIElementsManager.createLabel(with: "Enter a username:", fontSize: 24, textAlignment: .center, isHeader: true)
    var usernameTextField = UIElementsManager.createTextField(with: "Username")
    
    var choosePacksLabel = UIElementsManager.createLabel(with: "Choose packs:", fontSize: 24, textAlignment: .center, isHeader: true)
    
    var packStackView = UIElementsManager.createStackView(layoutMargins: UIEdgeInsets(top: 0, left: UIElementsManager.padding / 2, bottom: 0, right: UIElementsManager.padding / 2), axis: .horizontal, spacing: UIElementsManager.padding)
    var packOneView = UIElementsManager.createPackView(packColor: .packOneColor, packNumberString: "1", packName: "Standard\nPack")
    var packTwoView = UIElementsManager.createPackView(packColor: .packTwoColor, packNumberString: "2", packName: "Standard\nPack")
    var specialPackView = UIElementsManager.createPackView(packColor: .specialPackColor, packNumberString: "1", packName: "Special\nPack")
    
    var timeLabel = UIElementsManager.createLabel(with: "Pick a time limit:", fontSize: 24, textAlignment: .center, isHeader: true)
    var disclaimerLabel = UIElementsManager.createLabel(with: "Time limits must be 10 minutes or less", fontSize: 13)
    
    var timeLimitTextField = UIElementsManager.createNumberTextField()
    
    var back = UIElementsManager.createButton(with: "Back", color: .secondaryBackgroundColor)
    var create = UIElementsManager.createButton(with: "Create")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = .primaryBackgroundColor
        
        addSubviews(newGameLabel, newGameStackView, back, create)
        usernameView.addSubviews(usernameLabel, usernameTextField)
        packView.addSubviews(choosePacksLabel, packStackView)
        timeView.addSubviews(timeLabel, disclaimerLabel, timeLimitTextField)
        
        newGameStackView.addArrangedSubview(usernameView)
        newGameStackView.addArrangedSubview(packView)
        newGameStackView.addArrangedSubview(timeView)
        
        packStackView.addArrangedSubview(packOneView)
        packStackView.addArrangedSubview(packTwoView)
        packStackView.addArrangedSubview(specialPackView)

        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            newGameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            newGameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            newGameStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newGameStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newGameStackView.topAnchor.constraint(equalTo: newGameLabel.bottomAnchor),
            newGameStackView.bottomAnchor.constraint(equalTo: back.topAnchor),
            usernameView.widthAnchor.constraint(equalToConstant: UIElementsManager.windowWidth),
            packView.widthAnchor.constraint(equalToConstant: UIElementsManager.windowWidth),
            timeView.widthAnchor.constraint(equalToConstant: UIElementsManager.windowWidth),
            
            usernameLabel.leadingAnchor.constraint(equalTo: usernameView.leadingAnchor, constant: UIElementsManager.padding),
            usernameLabel.topAnchor.constraint(greaterThanOrEqualTo: usernameView.topAnchor, constant: 0),
            usernameLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -14),
            
            usernameTextField.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor, constant: 29),
            usernameTextField.leadingAnchor.constraint(equalTo: usernameView.leadingAnchor, constant: UIElementsManager.padding),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameView.trailingAnchor, constant: -UIElementsManager.padding),
            
            choosePacksLabel.leadingAnchor.constraint(equalTo: packView.leadingAnchor, constant: UIElementsManager.padding),
            choosePacksLabel.topAnchor.constraint(greaterThanOrEqualTo: packView.topAnchor, constant: 0),
            choosePacksLabel.bottomAnchor.constraint(equalTo: packStackView.topAnchor, constant: -14),
            
            packStackView.centerYAnchor.constraint(equalTo: packView.centerYAnchor, constant: 29),
            packStackView.leadingAnchor.constraint(equalTo: packView.leadingAnchor, constant: UIElementsManager.padding / 2),
            packStackView.trailingAnchor.constraint(equalTo: packView.trailingAnchor, constant: -UIElementsManager.padding / 2),
            
            timeLimitTextField.centerYAnchor.constraint(equalTo: timeView.centerYAnchor),
            timeLimitTextField.trailingAnchor.constraint(equalTo: timeView.trailingAnchor, constant: -UIElementsManager.padding),
            
            timeLabel.topAnchor.constraint(equalTo: timeLimitTextField.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timeView.leadingAnchor, constant: UIElementsManager.padding),
            
            disclaimerLabel.bottomAnchor.constraint(equalTo: timeLimitTextField.bottomAnchor),
            disclaimerLabel.leadingAnchor.constraint(equalTo: timeView.leadingAnchor, constant: UIElementsManager.padding),
            
            create.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -87),
            create.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            create.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding),
            
            back.bottomAnchor.constraint(equalTo: create.topAnchor, constant: -24),
            back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            back.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding)
            ])
    }

}
