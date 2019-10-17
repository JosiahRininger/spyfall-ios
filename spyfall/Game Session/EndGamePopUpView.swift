//
//  EndGamePopUpView.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/16/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class EndGamePopUpView: UIView {
    lazy var endGamePopUpView = CustomPopUpView(frame: .zero, title: "End Game", twoButtons: true)
    lazy var endGameLabel = UIElementsManager.createLabel(with: "Are you sure you want to end the game?", fontSize: 24, color: .subText, textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        addSubview(endGamePopUpView)
        setupEndGamePopUpView()
    }
    
    private func setupEndGamePopUpView() {
        endGamePopUpView.cancelButton.setTitle("No", for: .normal)
        endGamePopUpView.doneButton.setTitle("Yes", for: .normal)
        
        endGamePopUpView.addSubview(endGameLabel)
        
        NSLayoutConstraint.activate([
            endGameLabel.topAnchor.constraint(equalTo: endGamePopUpView.titleLabel.bottomAnchor, constant: 5),
            endGameLabel.leadingAnchor.constraint(equalTo: endGamePopUpView.popUpView.leadingAnchor, constant: 20),
            endGameLabel.trailingAnchor.constraint(equalTo: endGamePopUpView.popUpView.trailingAnchor, constant: -20),
            
            endGamePopUpView.doneButton.topAnchor.constraint(equalTo: endGameLabel.bottomAnchor, constant: 15)
            ])
    }
    
}
