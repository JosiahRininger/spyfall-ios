//
//  HomeView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class HomeView: UIView {

    var welcomeToLabel = UIElementsManager.createHeaderLabel(with: "Welcome to", fontSize: 45)
    
    var spyfallLabel = UIElementsManager.createHeaderLabel(with: "Spyfall", fontSize: 81)
    
    var newGame = UIElementsManager.createGenericButton(with: "New Game", color: .white)
    
    var joinGame = UIElementsManager.createGenericButton(with: "Join Game")
    
    var infoIcon = UIElementsManager.createInfoImageView()
    
    var rulesLabel = UIElementsManager.createGenericLabel(with: "Rules", fontSize: 14, color: .secondaryColor)
    
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
        
        addSubviews(welcomeToLabel, spyfallLabel, newGame, joinGame, infoIcon, rulesLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            infoIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -89),
            infoIcon.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -11),
            
            rulesLabel.centerYAnchor.constraint(equalTo: infoIcon.centerYAnchor),
            rulesLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            joinGame.bottomAnchor.constraint(equalTo: infoIcon.topAnchor, constant: -37),
            joinGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            joinGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            newGame.bottomAnchor.constraint(equalTo: joinGame.topAnchor, constant: -24),
            newGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            newGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            welcomeToLabel.topAnchor.constraint(equalTo: topAnchor, constant: 153),
            welcomeToLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding * 3),
            welcomeToLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding * 3),
            
            spyfallLabel.topAnchor.constraint(equalTo: welcomeToLabel.bottomAnchor),
            spyfallLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding * 3),
            spyfallLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding * 3)
            ])
    }
    
}
