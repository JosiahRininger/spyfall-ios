//
//  GameSessionView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/23/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class GameSessionView: UIView {
    
    var timerLabel = UIElementsManager.createLabel(with: "", fontSize: 48, textAlignment: .center, isHeader: true)
    var userInfoView = UIElementsManager.createUserInfoView()
    
    var playersLabel = UIElementsManager.createLabel(with: "Players:", fontSize: 24, textAlignment: .center, isHeader: true)
    var playersCollectionHeight = NSLayoutConstraint()
    var playersCollectionView = UIElementsManager.createCollectionView()
    
    var locationsLabel = UIElementsManager.createLabel(with: "Locations:", fontSize: 24, textAlignment: .center, isHeader: true)
    var locationsCollectionHeight = NSLayoutConstraint()
    var locationsCollectionView = UIElementsManager.createCollectionView()
    
    var endGameTopAnchor = NSLayoutConstraint()
    var endGame = UIElementsManager.createButton(with: "End Game")
    var playAgain = UIElementsManager.createButton(with: "Play Again", color: .secondaryBackgroundColor)

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
        translatesAutoresizingMaskIntoConstraints = false
        
        playAgain.isHidden = true
        
        playersCollectionHeight = playersCollectionView.heightAnchor.constraint(equalToConstant: 0)
        locationsCollectionHeight = locationsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        endGameTopAnchor = endGame.topAnchor.constraint(equalTo: locationsCollectionView.bottomAnchor, constant: 24)
        
        playersCollectionView.register(PlayersCollectionViewCell.self, forCellWithReuseIdentifier: Constants.IDs.playersCollectionViewCellId)
        locationsCollectionView.register(LocationsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.IDs.locationsCollectionViewCellId)
        
        addSubviews(timerLabel, userInfoView, playersLabel, playersCollectionView, locationsLabel, locationsCollectionView, playAgain, endGame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        playersCollectionHeight.isActive = true
        locationsCollectionHeight.isActive = true
        endGameTopAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65),
            
            userInfoView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 22),
            userInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            userInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding),
            userInfoView.heightAnchor.constraint(equalToConstant: 100),
            
            playersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            playersLabel.topAnchor.constraint(equalTo: userInfoView.subView.bottomAnchor, constant: 24),
            playersLabel.bottomAnchor.constraint(equalTo: playersCollectionView.topAnchor, constant: -4),

            playersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding - 2),
            playersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding + 2),
            
            locationsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            locationsLabel.topAnchor.constraint(equalTo: playersCollectionView.bottomAnchor, constant: 30),
            locationsLabel.bottomAnchor.constraint(equalTo: locationsCollectionView.topAnchor, constant: -4),
            
            locationsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            locationsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding),
            
            endGame.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -87),
            endGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            endGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding),
            
            playAgain.topAnchor.constraint(equalTo: locationsCollectionView.bottomAnchor, constant: 24),
            playAgain.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            playAgain.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding)
            ])
    }
}
