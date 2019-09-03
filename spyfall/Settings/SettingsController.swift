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
    var colors = [UIColor]()
    var selectedColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIColor.colors.forEach { colors.append($0.value) }
        
        settingsView.colorsCollectionView.delegate = self
        settingsView.colorsCollectionView.dataSource = self
        
        settingsView.back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        settingsView.colorView.addGestureRecognizer(colorTapGesture)
        let infoTapGesture = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        settingsView.infoView.addGestureRecognizer(infoTapGesture)
        let adTapGesture = UITapGestureRecognizer(target: self, action: #selector(adTapped))
        settingsView.adView.addGestureRecognizer(adTapGesture)
        
        setupView()
    }
    
    func setupView() {
        view = settingsView
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func colorTapped() {
        settingsView.colorPopUpView.isHidden = false
    }
    
    @objc func infoTapped() {
        settingsView.infoPopUpView.isHidden = false
    }
    
    @objc func adTapped() {
        settingsView.adPopUpView.isHidden = false
    }

}

extension SettingsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Returns count of all colors plus 1 for the random color option
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IDs.colorsCellId, for: indexPath) as? ColorsCell else { return UICollectionViewCell() }
        cell.configure(color: colors[indexPath.row])
        cell.isChecked = selectedColor == cell.cellBackgroundView.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = settingsView.colorsCollectionView.cellForItem(at: indexPath) as? ColorsCell
        cell?.isChecked = true
        selectedColor = selectedColor == cell?.cellBackgroundView.backgroundColor ? UIColor() : cell?.cellBackgroundView.backgroundColor ?? UIColor()
        collectionView.reloadData()
//        UserDefaults.set
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIElementSizes.colorWidth, height: UIElementSizes.colorHeight)
    }
}
