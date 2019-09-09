//
//  GameSessionView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/23/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class GameSessionView: UIView {
    
    var timerLabel = UIElementsManager.createLabel(with: "8:00", fontSize: 48, textAlignment: .center, isHeader: true)
    
    var userInfoView = UIElementsManager.createUserInfoView()
    
    var playersLabel = UIElementsManager.createLabel(with: "Players:", fontSize: 24, textAlignment: .center, isHeader: true)
    
    var playersCollectionHeight = NSLayoutConstraint()
    var playersCollectionView = UIElementsManager.createCollectionView()
    
    var locationsLabel = UIElementsManager.createLabel(with: "Locations:", fontSize: 24, textAlignment: .center, isHeader: true)
    
    var locationsCollectionHeight = NSLayoutConstraint()
    var locationsCollectionView = UIElementsManager.createCollectionView()
    
    var endGame = UIElementsManager.createButton(with: "End Game")
    
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
        
        playersCollectionHeight = playersCollectionView.heightAnchor.constraint(equalToConstant: 0)
        locationsCollectionHeight = locationsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        playersCollectionView.register(PlayersCollectionViewCell.self, forCellWithReuseIdentifier: Constants.IDs.playersCollectionViewCellId)
        locationsCollectionView.register(LocationsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.IDs.locationsCollectionViewCellId)
        
        addSubviews(timerLabel, userInfoView, playersLabel, playersCollectionView, locationsLabel, locationsCollectionView, endGame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        playersCollectionHeight.isActive = true
        locationsCollectionHeight.isActive = true
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65),
            
            userInfoView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 22),
            userInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            userInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            userInfoView.heightAnchor.constraint(equalToConstant: 100),
            
            playersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            playersLabel.topAnchor.constraint(equalTo: userInfoView.subView.bottomAnchor, constant: 24),
            playersLabel.bottomAnchor.constraint(equalTo: playersCollectionView.topAnchor, constant: -4),

            playersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            playersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            locationsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            locationsLabel.topAnchor.constraint(equalTo: playersCollectionView.bottomAnchor, constant: 30),
            locationsLabel.bottomAnchor.constraint(equalTo: locationsCollectionView.topAnchor, constant: -4),
            
            locationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            locationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            endGame.topAnchor.constraint(equalTo: locationsCollectionView.bottomAnchor, constant: 24),
            endGame.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -87),
            endGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.buttonPadding),
            endGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.buttonPadding)
            
            ])
    }
    
}
