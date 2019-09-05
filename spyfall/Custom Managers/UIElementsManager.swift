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

enum UIElementsManager {
    
    static func createLabel(with title: String, fontSize: CGFloat, numberOfLines: Int = 1, color: UIColor = .black, textAlignment: NSTextAlignment = .natural, isHeader: Bool = false) -> UILabel {
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
        t.backgroundColor = .white
        t.textColor = .black
        t.placeholder = placeholder
        t.tintColor = .secondaryColor
        t.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.textFieldHeight))
        t.leftViewMode = .always
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 9
        t.layer.borderColor = UIColor.secondaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        
        return t
    }
    
    static func createNumberTextField() -> UITextField {
        let t = UITextField()
        t.backgroundColor = .white
        t.textColor = .black
        t.textAlignment = .center
        t.tintColor = .clear
        t.keyboardType = .numberPad
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 9
        t.layer.borderColor = UIColor.secondaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        t.widthAnchor.constraint(equalToConstant: UIElementSizes.numberTextFieldWidth).isActive = true
        
        return t
    }
    
    static func createButton(with title: String, color: UIColor = .secondaryColor) -> Button {
        let b = Button()
        b.backgroundColor = color
        b.setTitleColor(color != .white ? .primaryWhite : .black, for: .normal)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 20)
        b.layer.cornerRadius = 30
        b.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.buttonHeight).isActive = true
        
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
        b.setBackgroundImage(UIImage(named: "Settings_Icon"), for: .normal)
        b.addShadowWith(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.16)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.settingsButtonHeightAndWidth).isActive = true
        b.widthAnchor.constraint(equalToConstant: UIElementSizes.settingsButtonHeightAndWidth).isActive = true
        
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
        pv.heightAnchor.constraint(equalToConstant: UIElementSizes.packViewHeight).isActive = true
        pv.widthAnchor.constraint(equalToConstant: UIElementSizes.packViewWidth).isActive = true
        
        return pv
    }
    
    static func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: UIElementSizes.padding, bottom: 10, right: UIElementSizes.padding)
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
        uv.heightAnchor.constraint(equalToConstant: UIElementSizes.packViewHeight).isActive = true
        uv.widthAnchor.constraint(equalToConstant: UIElementSizes.packViewWidth).isActive = true
        
        return uv
    }
    
    static func createCircleView() -> UIView {
        let v = UIView()
        v.backgroundColor = .secondaryColor
        v.layer.cornerRadius = UIElementSizes.circleViewHeightAndWidth / 2
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: UIElementSizes.circleViewHeightAndWidth).isActive = true
        v.widthAnchor.constraint(equalToConstant: UIElementSizes.circleViewHeightAndWidth).isActive = true
        
        return v
    }
    
    static func createTableView() -> UITableView {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.separatorInset = .zero
        tv.isScrollEnabled = false
        tv.rowHeight = UIElementSizes.tableViewCellHeight
        tv.backgroundColor = .primaryWhite
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }
    
    static func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

//        let width = UIElementSizes.navigationTabBarItemWidth
//        let height = UIScreen.main.bounds.height / 10
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: UIElementSizes.navigationTabBarItemHeight)
//        layout.minimumInteritemSpacing =
//        layout.minimumLineSpacing = 14
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .primaryWhite
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }

}
