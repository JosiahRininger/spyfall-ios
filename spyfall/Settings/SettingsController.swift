//
//  SettingsController.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

final class SettingsController: UIViewController {

    var settingsView = SettingsView()
    var colors: [UIColor] = []
    var selectedColor = UIColor.clear
    var homeVC = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.colorsCollectionView.delegate = self
        settingsView.colorsCollectionView.dataSource = self
        
        getColors()
        retrieveSavedColor()
        
        setupButtonActions()
        setupView()
    }
    
    private func setupView() {
        view = settingsView
    }
    
    private func setupButtonActions() {
        settingsView.back.touchUpInside = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        // Sets up the actions around the color pop up
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        settingsView.colorView.addGestureRecognizer(colorTapGesture)
        settingsView.colorPopUpView.cancelButton.touchUpInside = { [weak self] in self?.resetViews() }
        settingsView.colorPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.resetViews()
            self?.checkUserDefaults()
            UIColor.secondaryColor = self?.retrieveSavedColor() ?? UIColor.blue
            self?.settingsView.colorPopUpView.doneButton.backgroundColor = .secondaryColor
            self?.settingsView.infoPopUpView.doneButton.backgroundColor = .secondaryColor
            self?.settingsView.emailLabel.textColor = .secondaryColor
            self?.settingsView.adPopUpView.doneButton.backgroundColor = .secondaryColor
            self?.homeVC.viewWillAppear(true)
        }
        
        // Sets up the actions around the info pop up
        let infoTapGesture = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        settingsView.infoView.addGestureRecognizer(infoTapGesture)
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        settingsView.emailLabel.isUserInteractionEnabled = true
        settingsView.emailLabel.addGestureRecognizer(emailTapGesture)
        settingsView.infoPopUpView.doneButton.touchUpInside = { [weak self] in self?.resetViews() }
        
        // Sets up the actions around the remove ad pop up
        let adTapGesture = UITapGestureRecognizer(target: self, action: #selector(adTapped))
        settingsView.adView.addGestureRecognizer(adTapGesture)
        settingsView.adPopUpView.cancelButton.touchUpInside = { [weak self] in self?.resetViews() }
        settingsView.adPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.resetViews()
        }
    }
    
    @objc private func colorTapped() {
        settingsView.settingsStackView.isUserInteractionEnabled = false
        settingsView.back.isUserInteractionEnabled = false
        selectedColor = retrieveSavedColor()
        settingsView.colorPopUpView.isHidden = false
    }
    
    @objc private func infoTapped() {
        settingsView.settingsStackView.isUserInteractionEnabled = false
        settingsView.back.isUserInteractionEnabled = false
        settingsView.infoPopUpView.isHidden = false
    }
    
    @objc private func emailTapped() {
        if let text = settingsView.emailLabel.text, let url = URL(string: "mailto:\(text)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func adTapped() {
        settingsView.settingsStackView.isUserInteractionEnabled = false
        settingsView.back.isUserInteractionEnabled = false
        settingsView.adPopUpView.isHidden = false
    }
    
    @discardableResult private func retrieveSavedColor() -> UIColor {
        guard let colorString = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.secondaryColor) as? String else { return UIColor.clear }
        switch colorString {
        case ColorOptions.purple.rawValue: selectedColor = .customPurple
        case ColorOptions.blue.rawValue: selectedColor = .customBlue
        case ColorOptions.green.rawValue: selectedColor = .customGreen
        case ColorOptions.orange.rawValue: selectedColor = .customOrange
        case ColorOptions.red.rawValue: selectedColor = .customRed
        case ColorOptions.random.rawValue: selectedColor = .secondaryBackgroundColor; return UIColor.colors.randomElement()?.value ?? UIColor.blue
        default: return UIColor.colors.randomElement()?.value ?? UIColor.blue
        }
        return selectedColor
    }
    
    private func resetViews() {
        self.settingsView.settingsStackView.isUserInteractionEnabled = true
        self.settingsView.back.isUserInteractionEnabled = true
        self.settingsView.colorPopUpView.isHidden = true
        self.settingsView.infoPopUpView.isHidden = true
        self.settingsView.adPopUpView.isHidden = true
    }
    
    private func getColors() {
        colors.append(.customPurple)
        colors.append(.customBlue)
        colors.append(.customGreen)
        colors.append(.customOrange)
        colors.append(.customRed)
    }
    
    private func checkUserDefaults() {
        // TODO: possibly set default without checking
        if let colorString = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.secondaryColor) {
            switch selectedColor {
            case .customPurple:
                if colorString != ColorOptions.purple.rawValue {
                    UserDefaults.standard.set(ColorOptions.purple.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
                }
            case .customBlue:
                if colorString != ColorOptions.blue.rawValue {
                    UserDefaults.standard.set(ColorOptions.blue.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
                }
            case .customGreen:
                if colorString != ColorOptions.green.rawValue {
                    UserDefaults.standard.set(ColorOptions.green.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
                }
            case .customOrange:
                if colorString != ColorOptions.orange.rawValue {
                    UserDefaults.standard.set(ColorOptions.orange.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
                }
            case .customRed:
                if colorString != ColorOptions.red.rawValue {
                    UserDefaults.standard.set(ColorOptions.red.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
                }
            case .secondaryBackgroundColor:
                if colorString != ColorOptions.random.rawValue {
                    UserDefaults.standard.set(ColorOptions.random.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
                }
            default: print("Could not correctly retrieve user default")
            }
        }
    }
}

extension SettingsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Returns count of all colors plus 1 for the random color option
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.colorsCollectionViewCellId, for: indexPath) as? ColorsCell else { return UICollectionViewCell() }
        indexPath.row < colors.count ? cell.configure(color: colors[indexPath.row]) : cell.configure(labelText: "Random Color".localize())
        cell.isChecked = selectedColor == cell.cellBackgroundView.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = settingsView.colorsCollectionView.cellForItem(at: indexPath) as? ColorsCell else { return }
        if !cell.isChecked {
            cell.isChecked = true
            selectedColor = cell.cellBackgroundView.backgroundColor ?? UIColor.clear
            collectionView.reloadData()
        }
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIElementsManager.colorWidth, height: UIElementsManager.colorHeight)
    }
}
