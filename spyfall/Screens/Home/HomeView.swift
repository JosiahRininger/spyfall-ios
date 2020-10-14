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

    var welcomeToLabel = UIElementsManager.createLabel(with: "Welcome to".localize(), fontSize: 45, textAlignment: .center, isHeader: true)
    var spyfallLabel = UIElementsManager.createLabel(with: "Spyfall".localize(), fontSize: 81, textAlignment: .center, isHeader: true)
    
    var newGame = UIElementsManager.createButton(with: "New Game".localize(), color: .secondaryBackgroundColor)
    var joinGame = UIElementsManager.createButton(with: "Join Game".localize())
    
    var rulesView = UIElementsManager.createView(isUserInteractionEnabled: true)
    var infoView: UIView = {
        var v = UIElementsManager.createCircleView()
        v.addShadowWith(radius: 3, offset: CGSize(width: 0, height: 3), opacity: 0.16)
        
        var i = UIElementsManager.createLabel(with: "i", fontSize: 14, color: .hexToColor(hexString: "#FCFCFC"), textAlignment: .center, isHeader: true)
        v.addSubview(i)
        i.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        i.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        return v
    }()
    var rulesLabel = UIElementsManager.createLabel(with: "Rules".localize(), fontSize: 14, color: .secondaryColor)
    
    var rulesPopUpView = CustomPopUpView(frame: .zero, title: "Rules".localize())
    lazy var gameRulesLabel = UIElementsManager.createLabel(with: "Rules Message".localize(), fontSize: 16, numberOfLines: 0, color: .subText, textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = .primaryBackgroundColor
        
        addSubviews(settings, welcomeToLabel, spyfallLabel, newGame, joinGame, rulesView, rulesPopUpView)
        rulesView.addSubviews(infoView, rulesLabel)
        rulesPopUpView.alpha = 0.0
        
        setupConstraints()
        setupRulesPopUpView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -89),
            infoView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -11),
            
            rulesLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            rulesLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            
            rulesView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            rulesView.trailingAnchor.constraint(equalTo: rulesLabel.trailingAnchor),
            rulesView.topAnchor.constraint(equalTo: infoView.topAnchor),
            rulesView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            
            joinGame.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -37),
            joinGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            joinGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding),
            
            newGame.bottomAnchor.constraint(equalTo: joinGame.topAnchor, constant: -24),
            newGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            newGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding),
            
            settings.topAnchor.constraint(equalTo: topAnchor, constant: UIElementsManager.statusBarHeight + 24),
            settings.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            welcomeToLabel.topAnchor.constraint(equalTo: topAnchor, constant: 153),
            welcomeToLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding * 3),
            welcomeToLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding * 3),
            
            spyfallLabel.topAnchor.constraint(equalTo: welcomeToLabel.bottomAnchor),
            spyfallLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding * 3),
            spyfallLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding * 3)
            ])
    }
    
    private func setupRulesPopUpView() {
        rulesPopUpView.addSubview(gameRulesLabel)
        rulesPopUpView.doneButton.setTitle("Okay", for: .normal)
        
        NSLayoutConstraint.activate([
            gameRulesLabel.topAnchor.constraint(equalTo: rulesPopUpView.titleLabel.bottomAnchor, constant: 5),
            gameRulesLabel.leadingAnchor.constraint(equalTo: rulesPopUpView.popUpView.leadingAnchor, constant: 20),
            gameRulesLabel.trailingAnchor.constraint(equalTo: rulesPopUpView.popUpView.trailingAnchor, constant: -20),

            rulesPopUpView.doneButton.topAnchor.constraint(equalTo: gameRulesLabel.bottomAnchor, constant: 15)
            ])
    }
    
}
