//
//  CustomPopUpView.swift
//  spyfall
//
//  Created by Josiah Rininger on 8/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class CustomPopUpView: UIView {
    
    var popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryWhite
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.masksToBounds = false
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 20)
        label.textAlignment = .center
        label.text = "Create Request"
        label.textColor = .black
        label.sizeToFit()
        label.layer.masksToBounds = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return label
    }()
    
    var numberTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.placeholder = "Enter your phone number"
        textField.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.textFieldHeight))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        
        return textField
    }()
    
    var reasonTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.placeholder = "Select Urgency"
        textField.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.textFieldHeight))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        
        return textField
    }()
    
    var optionalTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.placeholder = "Reason for call back (Optional)"
        textField.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.textFieldHeight))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        
        return textField
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .secondaryColor
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 5
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        
        isHidden = true
        isUserInteractionEnabled = false
        
        addSubviews(popUpView)
        popUpView.addSubviews(titleLabel, numberTextField, reasonTextField, optionalTextField, cancelButton, sendButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            popUpView.centerXAnchor.constraint(equalTo: centerXAnchor),
            popUpView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            popUpView.widthAnchor.constraint(equalTo: widthAnchor, constant: -24),
            popUpView.heightAnchor.constraint(equalToConstant: 355),
            
            titleLabel.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            titleLabel.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            
            numberTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            numberTextField.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            numberTextField.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            
            reasonTextField.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 15),
            reasonTextField.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            reasonTextField.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            
            optionalTextField.topAnchor.constraint(equalTo: reasonTextField.bottomAnchor, constant: 15),
            optionalTextField.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            optionalTextField.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            
            cancelButton.topAnchor.constraint(equalTo: optionalTextField.bottomAnchor, constant: 15),
            cancelButton.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 36),
            cancelButton.trailingAnchor.constraint(equalTo: optionalTextField.centerXAnchor, constant: -10),
            cancelButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -25),
            
            sendButton.topAnchor.constraint(equalTo: optionalTextField.bottomAnchor, constant: 15),
            sendButton.leadingAnchor.constraint(equalTo: optionalTextField.centerXAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -36),
            sendButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -25)
            
            ])
    }
}
