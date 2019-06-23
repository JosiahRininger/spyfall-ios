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
    
    var accessCodeLabel = UIElementsManager.createHeaderLabel(with: "access code", fontSize: 19)
    
    let cellId: String = "playerListCellId"
    
    var tableHeight = NSLayoutConstraint()
    var tableView = UIElementsManager.createTableView()
    
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
        
        tableView.register(PlayersWaitingTableViewCell.self, forCellReuseIdentifier: cellId)
        tableHeight = tableView.heightAnchor.constraint(equalToConstant: 58)
        
        addSubviews(timerLabel, userInfoView, accessCodeLabel, tableView, endGame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        tableHeight.isActive = true
        
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
//            codeLabel.leadingAnchor.constraint(equalTo: accessCodeLabel.trailingAnchor, constant: 11),
//            codeLabel.centerYAnchor.constraint(equalTo: accessCodeLabel.centerYAnchor),
//
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            endGame.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 24),
            endGame.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -87),
            endGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            endGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            ])
    }
    
}
