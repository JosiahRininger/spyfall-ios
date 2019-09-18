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
    
    static func createlineView() -> UIView {
        let v = UIView()
        v.backgroundColor = .primaryGray
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }
    
    static func createButton(with title: String) -> UIButton {
        let b = UIButton()
        b.backgroundColor = .white
        b.setTitleColor(.primaryGray, for: .normal)
        b.setTitle(title, for: .normal)
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        b.layer.borderColor = UIColor.primaryGray.cgColor
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: UIElementSizes.buttonHeight).isActive = true
        b.widthAnchor.constraint(equalToConstant: UIElementSizes.buttonWidth).isActive = true
        
        return b
    }
}
