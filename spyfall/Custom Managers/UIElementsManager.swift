//
//  UIElementsManager.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import GoogleMobileAds

class UIElementsManager {
    
    static var windowWidth: CGFloat = UIScreen.main.bounds.width
    static var windowHeight: CGFloat = UIScreen.main.bounds.height

    static var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    static var tableViewCellHeight: CGFloat = 70
    static var collectionViewCellHeight: CGFloat = 58
    
    static var buttonWidth: CGFloat = 144
    static var buttonHeight: CGFloat = 61
    
    static var textFieldHeight: CGFloat = 50

    static var packViewHeight: CGFloat = 116
    static var packViewWidth: CGFloat = 88
    
    static var numberTextFieldWidth: CGFloat = 52
    
    static var circleViewHeightAndWidth: CGFloat = 22
    static var pencilHeightAndWidth: CGFloat = 20
    static var settingsButtonHeightAndWidth: CGFloat = 30
    
    static var colorWidth: CGFloat = windowWidth / 6
    static var colorHeight: CGFloat = colorWidth * 0.88
    
    static var iconHeightAndWidth: CGFloat = 40
    
    static var padding: CGFloat = 30
    static var buttonPadding: CGFloat = 60
    
    static func createLabel(with title: String, fontSize: CGFloat, numberOfLines: Int = 1, color: UIColor = .mainText, textAlignment: NSTextAlignment = .natural, isHeader: Bool = false) -> UILabel {
        let l = UILabel()
        l.text = title
        l.textColor = color
        l.textAlignment = textAlignment
        l.font = isHeader ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        l.numberOfLines = numberOfLines
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }
    
    static func createTextField(with placeholder: String) -> UITextField {
        let t = UITextField()
        t.backgroundColor = .secondaryBackgroundColor
        t.textColor = .mainText
        t.placeholder = placeholder
        t.tintColor = .secondaryColor
        t.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textFieldHeight))
        t.leftViewMode = .always
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 9
        t.layer.borderColor = UIColor.secondaryGray.cgColor
        t.autocorrectionType = UITextAutocorrectionType.no
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        return t
    }
    
    static func createNumberTextField() -> UITextField {
        let t = UITextField()
        t.backgroundColor = .secondaryBackgroundColor
        t.textColor = .mainText
        t.textAlignment = .center
        t.tintColor = .secondaryColor
        t.keyboardType = .numberPad
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 9
        t.layer.borderColor = UIColor.secondaryGray.cgColor
        t.autocorrectionType = UITextAutocorrectionType.no
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        t.widthAnchor.constraint(equalToConstant: numberTextFieldWidth).isActive = true
        
        return t
    }
    
    static func createButton(with title: String, color: UIColor = .secondaryColor) -> Button {
        let b = Button()
        b.backgroundColor = color
        b.setTitleColor(color != .secondaryBackgroundColor ? .hexToColor(hexString: "#FCFCFC") : .mainText, for: .normal)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 20)
        b.layer.cornerRadius = 30
        b.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        return b
    }
    
    static func createImageView(with imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    static func createSettingsButton() -> Button {
        let b = Button()
        b.setBackgroundImage(UIImage.settings, for: .normal)
        b.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: settingsButtonHeightAndWidth).isActive = true
        b.widthAnchor.constraint(equalToConstant: settingsButtonHeightAndWidth).isActive = true
        
        return b
    }
    
    static func createView(isUserInteractionEnabled: Bool = false) -> UIView {
        let v = UIView()
        v.isUserInteractionEnabled = isUserInteractionEnabled
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }
    
    static func createPackView(packColor: UIColor, packNumberString: String, packName: String) -> PackView {
        let pv = PackView()
        pv.boundsLayerView.backgroundColor = packColor
        pv.numberLabel.text = packNumberString
        pv.packNameLabel.text = packName
        pv.layer.cornerRadius = 9
        pv.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        pv.isUserInteractionEnabled = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.heightAnchor.constraint(equalToConstant: packViewHeight).isActive = true
        pv.widthAnchor.constraint(equalToConstant: packViewWidth).isActive = true
        
        return pv
    }
    
    static func createStackView(layoutMargins: UIEdgeInsets = UIEdgeInsets(), axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .leading
        stackView.spacing = spacing
        stackView.distribution = .fillEqually
        stackView.layoutMargins = layoutMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }
    
    static func createUserInfoView() -> UserInfoView {
        let uv = UserInfoView()
        uv.layer.cornerRadius = 9
        uv.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        uv.isUserInteractionEnabled = true
        uv.translatesAutoresizingMaskIntoConstraints = false
        uv.heightAnchor.constraint(equalToConstant: packViewHeight).isActive = true
        uv.widthAnchor.constraint(equalToConstant: packViewWidth).isActive = true
        
        return uv
    }
    
    static func createCircleView() -> UIView {
        let v = UIView()
        v.backgroundColor = .secondaryColor
        v.layer.cornerRadius = circleViewHeightAndWidth / 2
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: circleViewHeightAndWidth).isActive = true
        v.widthAnchor.constraint(equalToConstant: circleViewHeightAndWidth).isActive = true
        
        return v
    }
    
    static func createTableView() -> UITableView {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.separatorInset = .zero
        tv.isScrollEnabled = false
        tv.rowHeight = tableViewCellHeight
        tv.backgroundColor = .primaryBackgroundColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }
    
    static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 2, bottom: 0, right: 2)
        
//        let width = navigationTabBarItemWidth
//        let height = UIScreen.main.bounds.height / 10
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: navigationTabBarItemHeight)
//        layout.minimumInteritemSpacing =
//        layout.minimumLineSpacing = 14
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .primaryBackgroundColor
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }
    
    static func createToolBar(with button: UIBarButtonItem) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = button
        doneButton.tintColor = .secondaryColor
        let flexibilitySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibilitySpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }

#if FREE
    static func createBannerView() -> GADBannerView {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        return bannerView
    }
#endif
    
}
