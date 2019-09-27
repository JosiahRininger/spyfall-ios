//
//  WaitingScreenView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/19/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class WaitingScreenView: UIView {
    
    var waitingForPlayersLabel: UILabel = {
        let l = UIElementsManager.createLabel(with: "Waiting for players...", fontSize: 40, textAlignment: .center, isHeader: true)
        l.textAlignment = .left
        
        return l
    }()
    
    var accessCodeLabel = UIElementsManager.createLabel(with: "Access code:", fontSize: 19, textAlignment: .center, isHeader: true)
    var codeLabel = UIElementsManager.createLabel(with: "", fontSize: 18)
        
    var tableHeight = NSLayoutConstraint()
    var tableView = UIElementsManager.createTableView()

    var leaveGame = UIElementsManager.createButton(with: "Leave Game", color: .secondaryBackgroundColor)
    var startGame = UIElementsManager.createButton(with: "Start Game")
    
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
        backgroundColor = .primaryBackgroundColor
        
        tableView.register(PlayersWaitingTableViewCell.self, forCellReuseIdentifier: Constants.IDs.playerListCellId)
        tableHeight = tableView.heightAnchor.constraint(equalToConstant: 58)
        
        addSubviews(waitingForPlayersLabel, accessCodeLabel, tableView, codeLabel, leaveGame, startGame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableHeight.isActive = true
        
        NSLayoutConstraint.activate([
            waitingForPlayersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            waitingForPlayersLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            waitingForPlayersLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            accessCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            accessCodeLabel.topAnchor.constraint(equalTo: waitingForPlayersLabel.bottomAnchor, constant: 30),
            accessCodeLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -14),
            
            codeLabel.leadingAnchor.constraint(equalTo: accessCodeLabel.trailingAnchor, constant: 11),
            codeLabel.centerYAnchor.constraint(equalTo: accessCodeLabel.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            leaveGame.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 18),
            leaveGame.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -24),
            leaveGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.buttonPadding),
            leaveGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.buttonPadding),
            
            startGame.topAnchor.constraint(equalTo: leaveGame.bottomAnchor, constant: -24),
            startGame.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -87),
            startGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.buttonPadding),
            startGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.buttonPadding)
        ])
    }
}
