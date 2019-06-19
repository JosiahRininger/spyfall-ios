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
    static var navigationBarHeight: CGFloat = 0
    static var tabBarHeight: CGFloat = 0
    static var statusBarHeight: CGFloat = 40
    static var navigationTabBarItemWidth: CGFloat = UIScreen.main.bounds.width / 4
    static var navigationTabBarItemHeight: CGFloat = 40
    static var ticketTableViewHeight: CGFloat = 120
    static var createTicketTableViewHeight: CGFloat = 35
    
    static var labelWidth: CGFloat = UIScreen.main.bounds.width - 50
    
    static var textFieldWidth: CGFloat = UIScreen.main.bounds.width - 50
    static var singleLineTextFieldHeight: CGFloat = 50
    static var multilineTextFieldHeight: CGFloat = 200
    
    static var segmentedControlWidth: CGFloat = UIScreen.main.bounds.width - 50
    static var segmentedControlHeight: CGFloat = 50
    
    static var buttonWidth: CGFloat = 144
    static var buttonAndTextFieldHeight: CGFloat = 45

    static var checkBoxHeightAndWidth: CGFloat = 40
    static var pickerViewTextFieldHeight: CGFloat = 30
    static var pickerViewTextFieldWidth: CGFloat = 25
    
    static var padding: CGFloat = 50
    
}
