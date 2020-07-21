//
//  ChangeNamePopUpView.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/10/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class ChangeNamePopUpView: UIView {
    lazy var changeNamePopUpView = CustomPopUpView(frame: .zero, title: "Change Name", twoButtons: true)
    lazy var textField = UIElementsManager.createTextField(with: "Enter a username")
    
    override var isHidden: Bool {
        didSet {
            isUserInteractionEnabled = !isHidden
            changeNamePopUpView.isHidden = isHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        addSubview(changeNamePopUpView)
        setupChangeNamePopUpView()
    }
    
    private func setupChangeNamePopUpView() {
        changeNamePopUpView.addSubview(textField)
        changeNamePopUpView.cancelButton.setTitle("Cancel", for: .normal)
        changeNamePopUpView.doneButton.setTitle("Okay", for: .normal)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: changeNamePopUpView.contentsView.topAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: changeNamePopUpView.popUpView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: changeNamePopUpView.popUpView.trailingAnchor, constant: -20),
            textField.bottomAnchor.constraint(equalTo: changeNamePopUpView.contentsView.bottomAnchor, constant: -20)
            ])
    }
    
}
