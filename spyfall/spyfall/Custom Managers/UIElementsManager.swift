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
        b.layer.shadowRadius = 4
        b.layer.shadowOffset = CGSize(width: 0, height: 4)
        b.layer.shadowOpacity = 0.16
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.buttonHeight).isActive = true
        
        return b
    }
    
    static func createPackView(packColor: UIColor, packNumberString: String, packName: String) -> PackView {
        let pv = PackView()
        pv.boundsLayerView.backgroundColor = packColor
        pv.numberLabel.text = packNumberString
        pv.packNameLabel.text = packName
        pv.layer.cornerRadius = 9
        pv.layer.shadowRadius = 4
        pv.layer.shadowOffset = CGSize(width: 0, height: 4)
        pv.layer.shadowOpacity = 0.16
        pv.isUserInteractionEnabled = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.heightAnchor.constraint(equalToConstant: UIElementSizes.packViewHeight).isActive = true
        pv.widthAnchor.constraint(equalToConstant: UIElementSizes.packViewWidth).isActive = true
        
        return pv
    }
    
    static func createUserInfoView() -> UserInfoView {
        let pv = UserInfoView()
        pv.layer.cornerRadius = 9
        pv.layer.shadowRadius = 4
        pv.layer.shadowOffset = CGSize(width: 0, height: 4)
        pv.layer.shadowOpacity = 0.16
        pv.isUserInteractionEnabled = true
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.heightAnchor.constraint(equalToConstant: UIElementSizes.packViewHeight).isActive = true
        pv.widthAnchor.constraint(equalToConstant: UIElementSizes.packViewWidth).isActive = true
        
        return pv
    }
    
    static func createGenericTextField(with placeholder: String) -> UITextField {
        let t = UITextField()
        t.backgroundColor = .white
        t.textColor = .black
        t.placeholder = placeholder
        t.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 12, height: UIElementSizes.textFieldHeight))
        t.leftViewMode = .always
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 9
        t.layer.borderColor = UIColor.primaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        
        return t
    }
    
    static func createNumberTextField() -> UITextField {
        let t = UITextField()
        t.backgroundColor = .white
        t.placeholder = "0"
        t.textColor = .black
        t.textAlignment = .center
        t.tintColor = .clear
        t.keyboardType = .numberPad
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 9
        t.layer.borderColor = UIColor.primaryGray.cgColor
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: UIElementSizes.textFieldHeight).isActive = true
        t.widthAnchor.constraint(equalToConstant: UIElementSizes.numberTextFieldWidth).isActive = true
        
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
    
    static func createHeaderLabel(with title: String, fontSize: CGFloat, color: UIColor = .black) -> UILabel {
        let l = UILabel()
        l.text = title
        l.textColor = color
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
    
    static func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.isScrollEnabled = false
        tableView.rowHeight = UIElementSizes.tableViewCellHeight
        tableView.backgroundColor = .primaryWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }

}
