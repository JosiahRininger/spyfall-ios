//
//  SettingsView.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    var settingsLabel = UIElementsManager.createLabel(with: "Settings", fontSize: 40, isHeader: true)
    
    var settingsStackView = UIElementsManager.createStackView()
    
    var infoView = UIElementsManager.createView()
    var colorView = UIElementsManager.createView()
    var adView = UIElementsManager.createView()
    
    var infoImageView = UIElementsManager.createImageView(with: "info_icon")
    var colorImageView = UIElementsManager.createImageView(with: "color_icon")
    var adImageView = UIElementsManager.createImageView(with: "ad_icon")
    
    var infoLabel = UIElementsManager.createLabel(with: "Info", fontSize: 30, isHeader: true)
    var colorLabel = UIElementsManager.createLabel(with: "Color", fontSize: 30, isHeader: true)
    var adLabel = UIElementsManager.createLabel(with: "Ad", fontSize: 30, isHeader: true)
    
    var back = UIElementsManager.createButton(with: "Back", color: .white)
    
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
        
        addSubview(settingsLabel)
        addSubviews(settingsLabel, settingsStackView, back)
        infoView.addSubviews(infoImageView, infoLabel)
        colorView.addSubviews(colorImageView, colorLabel)
        adView.addSubviews(adImageView, adLabel)
        settingsStackView.addArrangedSubview(infoView)
        settingsStackView.addArrangedSubview(colorView)
        settingsStackView.addArrangedSubview(adView)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            settingsStackView.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 30),
            settingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsStackView.heightAnchor.constraint(equalToConstant: UIElementSizes.windowHeight / 3),
            
            infoImageView.heightAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            infoImageView.widthAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            infoImageView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoImageView.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),
            
            colorImageView.heightAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            colorImageView.widthAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            colorImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            colorImageView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: colorImageView.centerYAnchor),
            colorLabel.leadingAnchor.constraint(equalTo: colorImageView.trailingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -8),
            
            adImageView.heightAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            adImageView.widthAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            adImageView.centerYAnchor.constraint(equalTo: adView.centerYAnchor),
            adImageView.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
            adLabel.centerYAnchor.constraint(equalTo: adImageView.centerYAnchor),
            adLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: 16),
            adLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
            
            back.topAnchor.constraint(equalTo: settingsStackView.bottomAnchor, constant: 18),
            back.centerXAnchor.constraint(equalTo: centerXAnchor),
            back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementSizes.padding),
            back.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementSizes.padding)
            ])
    }
    
}
