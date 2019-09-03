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
    
    var colorView = UIElementsManager.createView()
    var infoView = UIElementsManager.createView()
    var adView = UIElementsManager.createView()
    
    var colorImageView = UIElementsManager.createImageView(with: "color_icon")
    var infoImageView = UIElementsManager.createImageView(with: "info_icon")
    var adImageView = UIElementsManager.createImageView(with: "ad_icon")
    
    var colorLabel = UIElementsManager.createLabel(with: "Theme", fontSize: 30, isHeader: true)
    var infoLabel = UIElementsManager.createLabel(with: "About", fontSize: 30, isHeader: true)
    var adLabel = UIElementsManager.createLabel(with: "Ad", fontSize: 30, isHeader: true)
    
    var back = UIElementsManager.createButton(with: "Back", color: .white)
    
    lazy var colorPopUpView = CustomPopUpView(frame: .zero, title: "Change Theme", twoButtons: true)
    lazy var colorsCollectionView = UIElementsManager.createCollectionView()
    
    lazy var infoPopUpView = CustomPopUpView(frame: .zero, title: "Info about Creators")
    lazy var summaryLabel = UIElementsManager.createLabel(with: "This is a summary about Josiah Rininger and Eli Dangerfield, the creators of Spyfall!", fontSize: 14)
    
    lazy var adPopUpView = CustomPopUpView(frame: .zero, title: "Remove Ads?", twoButtons: true)
    lazy var adStatementLabel = UIElementsManager.createLabel(with: "Would you like to upgrade Spyfall to remove all ads?", fontSize: 14)
    
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
        
        colorsCollectionView.register(ColorsCell.self, forCellWithReuseIdentifier: Constants.IDs.colorsCellId)
        
        addSubview(settingsLabel)
        addSubviews(settingsLabel, settingsStackView, back)
        colorView.addSubviews(colorImageView, colorLabel)
        infoView.addSubviews(infoImageView, infoLabel)
        adView.addSubviews(adImageView, adLabel)
        settingsStackView.addArrangedSubview(colorView)
        settingsStackView.addArrangedSubview(infoView)
        settingsStackView.addArrangedSubview(adView)
        setupConstraints()
        
        addSubviews(colorPopUpView, infoPopUpView, adPopUpView)
        setupColorPopUpView()
        setupInfoPopUpView()
        setupAdPopUpView()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            
            settingsStackView.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 30),
            settingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsStackView.heightAnchor.constraint(equalToConstant: UIElementSizes.windowHeight / 3),
            
            colorImageView.heightAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            colorImageView.widthAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            colorImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            colorImageView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: colorImageView.centerYAnchor),
            colorLabel.leadingAnchor.constraint(equalTo: colorImageView.trailingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -8),
            
            infoImageView.heightAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            infoImageView.widthAnchor.constraint(equalToConstant: UIElementSizes.iconHeightAndWidth),
            infoImageView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoImageView.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),
            
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
    
    func setupColorPopUpView() {
        colorPopUpView.addSubview(colorsCollectionView)
        
        NSLayoutConstraint.activate([
            colorsCollectionView.topAnchor.constraint(equalTo: colorPopUpView.titleLabel.bottomAnchor, constant: 5),
            colorsCollectionView.leadingAnchor.constraint(equalTo: colorPopUpView.popUpView.leadingAnchor, constant: 10),
            colorsCollectionView.trailingAnchor.constraint(equalTo: colorPopUpView.popUpView.trailingAnchor, constant: -10),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 200),//CGFloat(4 / (UIColor.colors.count + 1)) * CGFloat(UIElementSizes.colorHeight + 20)),
            
            colorPopUpView.doneButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 10)
            ])
    }
    
    func setupInfoPopUpView() {
        
    }
    
    func setupAdPopUpView() {
        
    }
}
