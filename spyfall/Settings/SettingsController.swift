//
//  SettingsController.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

fileprivate enum PopUp {
    case color
    case info
    case ad
}

final class SettingsController: UIViewController, SettingsViewModelDelegate {
    private var settingsView = SettingsView()
    private var settingsViewModel: SettingsViewModel?
    private var secondaryColor = UIColor.secondaryColor
    private var parentVC: UIViewController?
    var selectedColor = UIColor.clear
    private let colors: [UIColor] = [
        .customPurple,
        .customBlue,
        .customGreen,
        .customOrange,
        .customRed
    ]
    
    init(parentVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.parentVC? = parentVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.colorsCollectionView.delegate = self
        settingsView.colorsCollectionView.dataSource = self
        settingsViewModel = SettingsViewModel(delegate: self)
        
        setupView()
    }
    
    // MARK: - Setup UI
    private func setupView() {
        setupButtons()
        view = settingsView
    }
    
    private func setupButtons() {
        settingsView.back.touchUpInside = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        // Sets up the actions around the color pop up
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        settingsView.colorView.addGestureRecognizer(colorTapGesture)
        settingsView.colorPopUpView.cancelButton.touchUpInside = { [weak self] in
            self?.setViews(for: .color, shouldHidePopUp: true)
        }
        settingsView.colorPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.colorPopUpDoneTapped()
        }
        
        // Sets up the actions around the info pop up
        let infoTapGesture = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        settingsView.infoView.addGestureRecognizer(infoTapGesture)
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        settingsView.emailLabel.isUserInteractionEnabled = true
        settingsView.emailLabel.addGestureRecognizer(emailTapGesture)
        settingsView.infoPopUpView.doneButton.touchUpInside = { [weak self] in
            self?.setViews(for: .info, shouldHidePopUp: true)
        }
        
        // Sets up the actions around the remove ad pop up
        let adTapGesture = UITapGestureRecognizer(target: self, action: #selector(adTapped))
        settingsView.adView.addGestureRecognizer(adTapGesture)
        settingsView.adPopUpView.cancelButton.touchUpInside = { [weak self] in
            self?.setViews(for: .ad, shouldHidePopUp: false)
        }
        settingsView.adPopUpView.doneButton.touchUpInside = { [weak self] in
            #if FREE
                if let url = URL(string: Constants.IDs.appStoreLinkURL) {
                    UIApplication.shared.open(url)
                }
            #endif
            self?.setViews(for: .ad, shouldHidePopUp: true)
        }
    }
    
    // MARK: - Helper Methods
    private func setViews(for popup: PopUp, shouldHidePopUp: Bool) {
        settingsView.settingsStackView.isUserInteractionEnabled = shouldHidePopUp
        settingsView.back.isUserInteractionEnabled = shouldHidePopUp
        switch popup {
        case .color: settingsView.colorPopUpView.isHidden = shouldHidePopUp
        case .info: settingsView.infoPopUpView.isHidden = shouldHidePopUp
        case .ad: settingsView.adPopUpView.isHidden = shouldHidePopUp
        }
    }
    
    @objc
    private func colorTapped() {
        settingsViewModel?.retrieveSavedColor()
        setViews(for: .color, shouldHidePopUp: false)
    }
    
    @objc
    private func infoTapped() {
        setViews(for: .info, shouldHidePopUp: false)
    }
    
    @objc
    private func adTapped() {
        setViews(for: .ad, shouldHidePopUp: false)
    }
    
    @objc
    private func emailTapped() {
        if let text = settingsView.emailLabel.text, let url = URL(string: "mailto:\(text)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func colorPopUpDoneTapped() {
        setViews(for: .color, shouldHidePopUp: true)
        UIColor.secondaryColor = self.secondaryColor
        settingsView.infoPopUpView.doneButton.backgroundColor = .secondaryColor
        settingsView.emailLabel.textColor = .secondaryColor
        settingsView.adPopUpView.doneButton.backgroundColor = .secondaryColor
        parentVC?.viewWillAppear(true)
    }
}

// MARK: - CollectionView Delegate & Data Source
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
            settingsViewModel?.setUserDefaultsColor()
            secondaryColor = selectedColor == .secondaryBackgroundColor
                ? UIColor.colors.randomElement()?.value ?? UIColor.blue
                : selectedColor
            UIView.animate(withDuration: 0.3, animations: {
                self.settingsView.colorPopUpView.doneButton.backgroundColor = self.secondaryColor
            })
            collectionView.reloadData()
        }
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIElementsManager.colorWidth, height: UIElementsManager.colorHeight)
    }
}
