//
//  SettingsView.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    var settingsLabel = UIElementsManager.createLabel(with: "Settings".localize(), fontSize: 40, textAlignment: .center, isHeader: true)
    
    var settingsStackView = UIElementsManager.createStackView()
    
    var colorView = UIElementsManager.createView(isUserInteractionEnabled: true)
    var infoView = UIElementsManager.createView(isUserInteractionEnabled: true)
    var adView = UIElementsManager.createView(isUserInteractionEnabled: true)
    
    var colorImageView = UIElementsManager.createImageView(with: "color_icon")
    var infoImageView = UIElementsManager.createImageView(with: "info_icon")
    var adImageView = UIElementsManager.createImageView(with: "ad_icon")
    
    var colorLabel = UIElementsManager.createLabel(with: "Theme".localize(), fontSize: 30, textAlignment: .center, isHeader: true)
    var infoLabel = UIElementsManager.createLabel(with: "About".localize(), fontSize: 30, textAlignment: .center, isHeader: true)
    var adLabel = UIElementsManager.createLabel(with: "Ads".localize(), fontSize: 30, textAlignment: .center, isHeader: true)
    
    var back = UIElementsManager.createButton(with: "Back".localize(), color: .secondaryBackgroundColor)
    
    lazy var colorPopUpView = CustomPopUpView(frame: .zero, title: "Change Theme".localize(), twoButtons: true)
    lazy var themeLabel = UIElementsManager.createLabel(with: "Choose your new theme".localize(), fontSize: 24, color: .subText, textAlignment: .center)
    lazy var colorsCollectionView = UIElementsManager.createCollectionView()
    
    lazy var infoPopUpView = CustomPopUpView(frame: .zero, title: "About".localize())
    lazy var summaryLabel = UIElementsManager.createLabel(with: "About Spyfall".localize(), fontSize: 24, numberOfLines: 0, color: .subText, textAlignment: .center)
    lazy var emailLabel = UIElementsManager.createLabel(with: "Spyfallmobile@gmail.com", fontSize: 24, color: .secondaryColor, textAlignment: .center)
    
    lazy var adPopUpView = CustomPopUpView(frame: .zero, title: "Remove Ads?".localize(), twoButtons: true)
    lazy var adStatementLabel = UIElementsManager.createLabel(with: "Would you like to upgrade?".localize(), fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        frame = CGRect(x: 0, y: 0, width: UIElementsManager.windowWidth, height: UIElementsManager.windowHeight)
        backgroundColor = .primaryBackgroundColor
        
        colorsCollectionView.register(ColorsCell.self, forCellWithReuseIdentifier: Constants.IDs.colorsCollectionViewCellId)
        
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
            settingsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 105),
            settingsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.padding),
            
            settingsStackView.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 30),
            settingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsStackView.heightAnchor.constraint(equalToConstant: UIElementsManager.windowHeight / 3),
            
            colorImageView.heightAnchor.constraint(equalToConstant: UIElementsManager.iconHeightAndWidth),
            colorImageView.widthAnchor.constraint(equalToConstant: UIElementsManager.iconHeightAndWidth),
            colorImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            colorImageView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: colorImageView.centerYAnchor),
            colorLabel.leadingAnchor.constraint(equalTo: colorImageView.trailingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -8),
            
            infoImageView.heightAnchor.constraint(equalToConstant: UIElementsManager.iconHeightAndWidth),
            infoImageView.widthAnchor.constraint(equalToConstant: UIElementsManager.iconHeightAndWidth),
            infoImageView.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoImageView.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8),
            
            adImageView.heightAnchor.constraint(equalToConstant: UIElementsManager.iconHeightAndWidth),
            adImageView.widthAnchor.constraint(equalToConstant: UIElementsManager.iconHeightAndWidth),
            adImageView.centerYAnchor.constraint(equalTo: adView.centerYAnchor),
            adImageView.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
            adLabel.centerYAnchor.constraint(equalTo: adImageView.centerYAnchor),
            adLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: 16),
            adLabel.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
            
            back.topAnchor.constraint(equalTo: settingsStackView.bottomAnchor, constant: 18),
            back.centerXAnchor.constraint(equalTo: centerXAnchor),
            back.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIElementsManager.buttonPadding),
            back.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIElementsManager.buttonPadding)
            ])
    }
    
    func setupColorPopUpView() {
        colorPopUpView.addSubviews(themeLabel, colorsCollectionView)
        colorPopUpView.cancelButton.setTitle("Cancel".localize(), for: .normal)
        colorPopUpView.doneButton.setTitle("Change".localize(), for: .normal)
        
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: colorPopUpView.titleLabel.bottomAnchor, constant: 5),
            themeLabel.leadingAnchor.constraint(equalTo: colorPopUpView.popUpView.leadingAnchor, constant: 20),
            themeLabel.trailingAnchor.constraint(equalTo: colorPopUpView.popUpView.trailingAnchor, constant: -20),
            
            colorsCollectionView.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 5),
            colorsCollectionView.leadingAnchor.constraint(equalTo: colorPopUpView.popUpView.leadingAnchor, constant: 20),
            colorsCollectionView.trailingAnchor.constraint(equalTo: colorPopUpView.popUpView.trailingAnchor, constant: -20),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: (CGFloat(4) / CGFloat(UIColor.colors.count + 1) + 1) * (UIElementsManager.colorHeight + CGFloat(30))),
            
            colorPopUpView.doneButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 15)
            ])
    }
    
    func setupInfoPopUpView() {
        infoPopUpView.addSubviews(summaryLabel, emailLabel)
        infoPopUpView.doneButton.setTitle("OK", for: .normal)
        
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: infoPopUpView.titleLabel.bottomAnchor, constant: 5),
            summaryLabel.leadingAnchor.constraint(equalTo: infoPopUpView.popUpView.leadingAnchor, constant: 20),
            summaryLabel.trailingAnchor.constraint(equalTo: infoPopUpView.popUpView.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 15),
            emailLabel.leadingAnchor.constraint(equalTo: infoPopUpView.popUpView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: infoPopUpView.popUpView.trailingAnchor, constant: -20),
            
            infoPopUpView.doneButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20)
            ])
    }
    
    func setupAdPopUpView() {
        adPopUpView.cancelButton.setTitle("Cancel".localize(), for: .normal)
        adPopUpView.doneButton.setTitle("Upgrade".localize(), for: .normal)
    }
}
