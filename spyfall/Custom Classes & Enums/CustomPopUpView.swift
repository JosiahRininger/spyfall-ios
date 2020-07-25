//
//  CustomPopUpView.swift
//  spyfall
//
//  Created by Josiah Rininger on 8/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class CustomPopUpView: UIView {
    
    lazy var twoButtons = Bool()
    
    lazy var popUpView: UIView = {
        let v = UIElementsManager.createView()
        v.backgroundColor = .primaryBackgroundColor
        v.layer.cornerRadius = 30
        v.layer.shadowColor = UIColor.popupShadow.cgColor
        v.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        v.layer.masksToBounds = false
        v.isUserInteractionEnabled = true
        
        return v
    }()

    lazy var titleLabel = UIElementsManager.createLabel(with: "", fontSize: 30, textAlignment: .center, isHeader: true)
    
    lazy var contentsView = UIElementsManager.createView(isUserInteractionEnabled: true)
    
    lazy var cancelButton = UIElementsManager.createButton(with: "", color: .secondaryBackgroundColor)
    lazy var doneButton = UIElementsManager.createButton(with: "")
    
    override var isHidden: Bool {
        didSet {
            isUserInteractionEnabled = !isHidden
            UIView.animate(withDuration: 0.3) {
                self.alpha = self.isHidden ? 0.0 : 1.0
            }
        }
    }
    
    init(frame: CGRect, title: String, twoButtons: Bool = false) {
        super.init(frame: frame)
        self.titleLabel.text = title
        self.twoButtons = twoButtons
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = UIColor.popupBackground.withAlphaComponent(0.4)
        
        isHidden = true
        addSubviews(popUpView)
        popUpView.addSubviews(titleLabel, contentsView, doneButton)
        if twoButtons { popUpView.addSubview(cancelButton) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            popUpView.centerXAnchor.constraint(equalTo: centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: centerYAnchor),
            popUpView.widthAnchor.constraint(equalTo: widthAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            titleLabel.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            
            contentsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            contentsView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            contentsView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            
            doneButton.topAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: 15),
            doneButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -25),
            doneButton.widthAnchor.constraint(equalToConstant: UIElementsManager.windowWidth / 3)
            ])
        
        if twoButtons {
            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: 15),
                cancelButton.trailingAnchor.constraint(equalTo: contentsView.centerXAnchor, constant: -12),
                cancelButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -25),
                cancelButton.widthAnchor.constraint(equalToConstant: UIElementsManager.windowWidth / 3),
                
                doneButton.leadingAnchor.constraint(equalTo: contentsView.centerXAnchor, constant: 12)
                ])
        } else {
            doneButton.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor).isActive = true
        }
    }
}
