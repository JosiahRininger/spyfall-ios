//
//  PacksPopUpView.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/12/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class PacksNamePopUpView: UIView {
    var packsNamePopUpView = CustomPopUpView(frame: .zero, title: "Packs Name", twoButtons: true)
    var textField = UIElementsManager.createTextField(with: "Enter a username")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        addSubview(packsNamePopUpView)
        setupPacksNamePopUpView()
    }
    
    private func setupPacksNamePopUpView() {
        packsNamePopUpView.addSubview(textField)
        packsNamePopUpView.cancelButton.setTitle("Cancel", for: .normal)
        packsNamePopUpView.doneButton.setTitle("Okay", for: .normal)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: packsNamePopUpView.contentsView.topAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: packsNamePopUpView.popUpView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: packsNamePopUpView.popUpView.trailingAnchor, constant: -20),
            textField.bottomAnchor.constraint(equalTo: packsNamePopUpView.contentsView.bottomAnchor, constant: -20)
            ])
    }
}
