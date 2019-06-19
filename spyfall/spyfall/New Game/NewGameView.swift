//
//  NewGameView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/18/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class NewGameView: UIView {
    
    let timeRange: [String] = ["1","2","3","4","5","6","7","8","9","10"]
    
    var welcomeLabel = UIElementsManager.createHeaderLabel(with: "Welcome to Spyfall")
    
    var topLine = UIElementsManager.createLineView()

    var nameTextField = UIElementsManager.createGenericTextField(with: "Enter a username")
    
    var locationsLabel = UIElementsManager.createGenericLabel(with: "Locations:")
    
    var packOneCheckBox = UIElementsManager.createCheckBoxButton()
    var packTwoCheckBox = UIElementsManager.createCheckBoxButton()
    var specialPackCheckBox = UIElementsManager.createCheckBoxButton()
    
    var packOneLabel = UIElementsManager.createGenericLabel(with: "Pack One")
    var packTwoLabel = UIElementsManager.createGenericLabel(with: "Pack Two")
    var specialPackLabel = UIElementsManager.createGenericLabel(with: "Special Pack")
    
    var timeLabel = UIElementsManager.createGenericLabel(with: "Time (in minutes)")
    
    var timeLimitTextField = UIElementsManager.createPickerViewTextField()
    
    var bottomLine = UIElementsManager.createLineView()
    
    var create = UIElementsManager.createGenericButton(with: "CREATE")

    var back = UIElementsManager.createGenericButton(with: "BACK")

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
        backgroundColor = .white
        
        addSubview(welcomeLabel)
        addSubview(topLine)
        addSubview(nameTextField)
        addSubview(locationsLabel)
        addSubview(packOneCheckBox)
        addSubview(packOneLabel)
        addSubview(packTwoCheckBox)
        addSubview(packTwoLabel)
        addSubview(specialPackCheckBox)
        addSubview(specialPackLabel)
        addSubview(timeLabel)
        addSubview(timeLimitTextField)
        addSubview(bottomLine)
        addSubview(create)
        addSubview(back)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            packOneCheckBox.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -5),
            packOneCheckBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            
            packTwoCheckBox.topAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            packTwoCheckBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            
            specialPackCheckBox.topAnchor.constraint(equalTo: packTwoCheckBox.bottomAnchor, constant: 10),
            specialPackCheckBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            
            packOneLabel.leadingAnchor.constraint(equalTo: packOneCheckBox.trailingAnchor, constant: 12),
            packOneLabel.centerYAnchor.constraint(equalTo: packOneCheckBox.centerYAnchor),
            
            packTwoLabel.leadingAnchor.constraint(equalTo: packTwoCheckBox.trailingAnchor, constant: 12),
            packTwoLabel.centerYAnchor.constraint(equalTo: packTwoCheckBox.centerYAnchor),
            
            specialPackLabel.leadingAnchor.constraint(equalTo: specialPackCheckBox.trailingAnchor, constant: 12),
            specialPackLabel.centerYAnchor.constraint(equalTo: specialPackCheckBox.centerYAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: specialPackLabel.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: specialPackLabel.leadingAnchor),
            
            timeLimitTextField.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 12),
            timeLimitTextField.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            
            bottomLine.topAnchor.constraint(equalTo: timeLimitTextField.bottomAnchor, constant: 30),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            create.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 30),
            create.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5),
            
            back.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 30),
            back.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5),
            
            locationsLabel.bottomAnchor.constraint(equalTo: packOneCheckBox.topAnchor, constant: -20),
            locationsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            
            nameTextField.bottomAnchor.constraint(equalTo: locationsLabel.topAnchor, constant: -30),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            topLine.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -30),
            topLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            topLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            
            welcomeLabel.bottomAnchor.constraint(equalTo: topLine.topAnchor, constant: -30),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding),
            ])
    }

}
