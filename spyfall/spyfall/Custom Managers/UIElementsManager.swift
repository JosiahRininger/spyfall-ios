//
//  LineView.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import UIKit

enum UIElementsManager {
    
    static func createLineView() -> UIView {
        let v = UIView()
        v.backgroundColor = .primaryGray
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }
    
    static func createGenericButton(with title: String, color: UIColor = .secondaryColor) -> UIButton {
        let b = UIButton()
        b.backgroundColor = color
        b.setTitleColor(color != .white ? .primaryWhite : .black, for: .normal)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 20)
        b.layer.cornerRadius = 30
        b.layer.shadowRadius = 3
        b.layer.shadowOffset = CGSize(width: 0, height: 5)
        b.layer.shadowOpacity = 0.16
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.buttonHeight).isActive = true
        
        return b
    }
    
    static func createPackView(packColor: UIColor, packNumberString: String, packName: String) -> PackView {
        let b = PackView()
        b.backgroundColor = packColor
        b.numberLabel.text = packNumberString
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.packViewHeight).isActive = true
        b.widthAnchor.constraint(equalToConstant: UIElementSizes.packViewWidth).isActive = true
        
        return b
    }
    
    static func createGenericTextField(with placeholder: String) -> UITextField {
        let t = UITextField()
        t.backgroundColor = .white
        t.textColor = .primaryGray
        t.placeholder = placeholder
        t.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.textFieldHeight))
        t.leftViewMode = .always
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 5
        t.layer.borderColor = UIColor.primaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        
        return t
    }
    
    static func createPickerViewTextField() -> UITextField {
        let t = UITextField()
        t.backgroundColor = .white
        t.textColor = .primaryGray
        t.textAlignment = .center
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 5
        t.layer.borderColor = UIColor.primaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.pickerViewTextFieldHeight).isActive = true
        t.widthAnchor.constraint(equalToConstant: UIElementSizes.pickerViewTextFieldWidth).isActive = true
        
        return t
    }
    
    static func createGenericLabel(with title: String, fontSize: CGFloat, color: UIColor = .black) -> UILabel {
        let l = UILabel()
        l.text = title
        l.textColor = color
        l.font = .systemFont(ofSize: fontSize)
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }
    
    static func createHeaderLabel(with title: String, fontSize: CGFloat) -> UILabel {
        let l = UILabel()
        l.text = title
        l.textColor = .black
        l.textAlignment = .center
        l.font = .boldSystemFont(ofSize: fontSize)
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }
    
    static func createInfoImageView() -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(named: "Info_Icon")
        iv.contentMode = .scaleAspectFill
        iv.layer.shadowRadius = 3
        iv.layer.shadowOffset = CGSize(width: 0, height: 3)
        iv.layer.shadowOpacity = 0.16
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: UIElementSizes.infoIconHeightAndWidth).isActive = true
        iv.widthAnchor.constraint(equalToConstant: UIElementSizes.infoIconHeightAndWidth).isActive = true
        
        return iv
    }

}
