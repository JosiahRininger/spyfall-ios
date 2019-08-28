//
//  HomeView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    var settings = UIElementsManager.createSettingsButton()

    var welcomeToLabel = UIElementsManager.createLabel(with: "Welcome to", fontSize: 45, isHeader: true)
    var spyfallLabel = UIElementsManager.createLabel(with: "Spyfall", fontSize: 81, isHeader: true)
    
    var newGame = UIElementsManager.createButton(with: "HomeViewNewGame".localize(), color: .white)
    var joinGame = UIElementsManager.createButton(with: "Join Game")
    
    var infoView: UIView = {
        var v = UIElementsManager.createCircleView()
        v.layer.shadowRadius = 3
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowOpacity = 0.16
        
        var i = UIElementsManager.createLabel(with: "i", fontSize: 14, color: .primaryWhite, isHeader: true)
        v.addSubview(i)
        i.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        i.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        return v
    }()
    var rulesLabel = UIElementsManager.createLabel(with: "Rules", fontSize: 14, color: .secondaryColor)
    
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
        
        addSubviews(settings, welcomeToLabel, spyfallLabel, newGame, joinGame, infoView, rulesLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            infoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -89),
            infoView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -11),
            
            rulesLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            rulesLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            joinGame.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -37),
            joinGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            joinGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            newGame.bottomAnchor.constraint(equalTo: joinGame.topAnchor, constant: -24),
            newGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            newGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            settings.topAnchor.constraint(equalTo: topAnchor, constant: UIElementSizes.statusBarHeight + 24),
            settings.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            welcomeToLabel.topAnchor.constraint(equalTo: topAnchor, constant: 153),
            welcomeToLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding * 3),
            welcomeToLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding * 3),
            
            spyfallLabel.topAnchor.constraint(equalTo: welcomeToLabel.bottomAnchor),
            spyfallLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding * 3),
            spyfallLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding * 3)
            ])
    }
    
}
