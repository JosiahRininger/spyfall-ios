//
//  NetworkErrorPopUpView.swift
//  spyfall
//
//  Created by Josiah Rininger on 1/7/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit

class NetworkErrorPopUpView: UIView {
    var networkErrorPopUpView = CustomPopUpView(frame: .zero, title: "Error title".localize(), twoButtons: false)
    var errorLabel = UIElementsManager.createLabel(with: "Error message".localize(), fontSize: 24, color: .subText, textAlignment: .center)
    
    override var isHidden: Bool {
        didSet {
            isUserInteractionEnabled = !isHidden
            networkErrorPopUpView.isHidden = isHidden
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
        
        addSubview(networkErrorPopUpView)
        setupNetworkErrorPopUpView()
    }
    
    private func setupNetworkErrorPopUpView() {
        networkErrorPopUpView.addSubview(errorLabel)
        networkErrorPopUpView.doneButton.setTitle("Okay", for: .normal)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: networkErrorPopUpView.titleLabel.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: networkErrorPopUpView.popUpView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: networkErrorPopUpView.popUpView.trailingAnchor, constant: -20),

            networkErrorPopUpView.doneButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 15)
            ])
    }
}
