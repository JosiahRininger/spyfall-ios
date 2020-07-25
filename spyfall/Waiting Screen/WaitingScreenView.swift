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
    var spinner = Spinner(frame: .zero)
    
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
        translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(PlayersWaitingTableViewCell.self, forCellReuseIdentifier: Constants.IDs.playerListCellId)
        tableHeight = tableView.heightAnchor.constraint(equalToConstant: 58)
        
        addSubviews(waitingForPlayersLabel, accessCodeLabel, tableView, codeLabel, leaveGame, startGame)
        spinner = Spinner(frame: CGRect(x: 45.0, y: startGame.frame.minY + 21.0, width: 20.0, height: 20.0))
        startGame.addSubview(spinner)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableHeight.isActive = true
        
        NSLayoutConstraint.activate([
            waitingForPlayersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            waitingForPlayersLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding),
            waitingForPlayersLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            accessCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            accessCodeLabel.topAnchor.constraint(equalTo: waitingForPlayersLabel.bottomAnchor, constant: 30),
            accessCodeLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -14),
            
            codeLabel.leadingAnchor.constraint(equalTo: accessCodeLabel.trailingAnchor, constant: 11),
            codeLabel.centerYAnchor.constraint(equalTo: accessCodeLabel.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.padding),
            
            leaveGame.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 18),
            leaveGame.bottomAnchor.constraint(equalTo: startGame.topAnchor, constant: -24),
            leaveGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            leaveGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding),
            
            startGame.topAnchor.constraint(equalTo: leaveGame.bottomAnchor, constant: -24),
            startGame.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -87),
            startGame.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            startGame.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding)
        ])
    }
}
