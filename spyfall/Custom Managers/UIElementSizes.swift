//
//  UIElementSizes.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

struct UIElementSizes {
    
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
}
