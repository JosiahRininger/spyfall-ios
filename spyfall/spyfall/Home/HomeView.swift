//
//  HomeView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class HomeView: UIView {

    var welcomeLabel = UIElementsManager.createHeaderLabel(with: "Welcome to Spyfall")
    
    var topLine = UIElementsManager.createLineView()
    
    var newGame = UIElementsManager.createGenericButton(with: "NEW GAME")
    
    var joinGame = UIElementsManager.createGenericButton(with: "JOIN GAME")
    
    var bottomLine = UIElementsManager.createLineView()
    
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
        addSubview(newGame)
        addSubview(joinGame)
        addSubview(bottomLine)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            newGame.centerYAnchor.constraint(equalTo: centerYAnchor),
            newGame.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5),
            
            joinGame.centerYAnchor.constraint(equalTo: centerYAnchor),
            joinGame.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5),

            bottomLine.topAnchor.constraint(equalTo: newGame.bottomAnchor, constant: 60),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),

            topLine.bottomAnchor.constraint(equalTo: newGame.topAnchor, constant: -60),
            topLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            topLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),

            welcomeLabel.bottomAnchor.constraint(equalTo: topLine.topAnchor, constant: -60),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding)])
    }
    
}
