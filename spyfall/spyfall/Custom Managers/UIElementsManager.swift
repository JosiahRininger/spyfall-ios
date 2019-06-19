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
    
    static func createGenericButton(with title: String) -> UIButton {
        let b = UIButton()
        b.backgroundColor = .white
        b.setTitleColor(.primaryGray, for: .normal)
        b.setTitle(title, for: .normal)
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        b.layer.borderColor = UIColor.primaryGray.cgColor
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.buttonAndTextFieldHeight).isActive = true
        b.widthAnchor.constraint(equalToConstant: UIElementSizes.buttonWidth).isActive = true
        
        return b
    }
    
    static func createCheckBoxButton() -> CheckBox {
        let b = CheckBox()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.checkBoxHeightAndWidth).isActive = true
        b.widthAnchor.constraint(equalToConstant: UIElementSizes.checkBoxHeightAndWidth).isActive = true
        
        return b
    }
    
    static func createGenericTextField(with placeholder: String) -> UITextField {
        let t = UITextField()
        t.backgroundColor = .white
        t.textColor = .primaryGray
        t.placeholder = placeholder
        t.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.buttonAndTextFieldHeight))
        t.leftViewMode = .always
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 5
        t.layer.borderColor = UIColor.primaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.buttonAndTextFieldHeight).isActive = true
        
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
    
    static func createGenericLabel(with title: String) -> UILabel {
        let l = UILabel()
        l.text = title
        l.textColor = .primaryGray
        l.font = .systemFont(ofSize: 17)
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }
    
    static func createHeaderLabel(with title: String) -> UILabel {
        let l = UILabel()
        l.text = title
        l.textColor = .primaryGray
        l.font = .systemFont(ofSize: 37)
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }
}
