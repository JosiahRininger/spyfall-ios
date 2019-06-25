//
//  GameSessionView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/23/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class GameSessionView: UIView {
    
    var timerLabel = UIElementsManager.createHeaderLabel(with: "8:00", fontSize: 48)
    
    var userInfoView = UIElementsManager.createUserInfoView()
    
    var playersLabel = UIElementsManager.createHeaderLabel(with: "Players:", fontSize: 24)
    
    let playersCollectionViewCellId: String = "playersCollectionViewCellId"
    var playersCollectionHeight = NSLayoutConstraint()
    var playersCollectionView = UIElementsManager.createCollectionView()
    
    var locationsLabel = UIElementsManager.createHeaderLabel(with: "Locations:", fontSize: 24)
    
    let locationsCollectionViewCellId: String = "locationsCollectionViewCellId"
    var locationsCollectionHeight = NSLayoutConstraint()
    var locationsCollectionView = UIElementsManager.createCollectionView()
    
    var endGame = UIElementsManager.createGenericButton(with: "End Game")
    
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
        
        playersCollectionHeight = playersCollectionView.heightAnchor.constraint(equalToConstant: 58)
        locationsCollectionHeight = locationsCollectionView.heightAnchor.constraint(equalToConstant: 58)
        
        playersCollectionView.register(UsernameCollectionViewCell.self, forCellWithReuseIdentifier: playersCollectionViewCellId)
        locationsCollectionView.register(LocationsCollectionViewCell.self, forCellWithReuseIdentifier: locationsCollectionViewCellId)
        
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
//            accessCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            accessCodeLabel.topAnchor.constraint(equalTo: waitingForPlayersLabel.bottomAnchor, constant: 30),
//            accessCodeLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -14),
//
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            endGame.topAnchor.constraint(equalTo: userInfoView.subView.bottomAnchor, constant: 24),
            endGame.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -87),
            endGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            endGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            ])
    }
    
}
