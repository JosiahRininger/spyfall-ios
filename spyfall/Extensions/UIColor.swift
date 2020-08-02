//
//  UIColor.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    static func hexToColor(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha ?? 1.0
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    // Theme Colors Used
    static let primaryBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "Background") ?? .hexToColor(hexString: "#FCFCFC")
        } else {
            return .hexToColor(hexString: "#FCFCFC")
        }
    }()
    
    static let secondaryBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "SecondaryBackground") ?? .white
        } else {
            return .white
        }
    }()
    static let mainText: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "MainText") ?? .black
        } else {
            return .black
        }
    }()

    static let subText: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "SubText") ?? .hexToColor(hexString: "#585858")
        } else {
            return .hexToColor(hexString: "#585858")
        }
    }()
    
    static let cellBackground: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "CellBackground") ?? .hexToColor(hexString: "#EEEEEE")
        } else {
            return .hexToColor(hexString: "#EEEEEE")
        }
    }()
    
    static let popupBackground: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "PopupBackground") ?? .hexToColor(hexString: "#222222")
        } else {
            return .hexToColor(hexString: "#222222")
        }
    }()
    
    static let popupShadow: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor(named: "PopupShadow") ?? .hexToColor(hexString: "#7F7F7F")
        } else {
            return .hexToColor(hexString: "#7F7F7F")
        }
    }()
    
    static let secondaryGray: UIColor = .hexToColor(hexString: "#707070")
    static let packOneColor: UIColor = .hexToColor(hexString: "#9533C7")
    static let packTwoColor: UIColor = .hexToColor(hexString: "#00A0EF")
    static let specialPackColor: UIColor = .hexToColor(hexString: "#2FD566")

    // Secondary Color Options
    static let customPurple: UIColor = .hexToColor(hexString: "#9533C7")
    static let customBlue: UIColor = .hexToColor(hexString: "#00A0EF")
    static let customGreen: UIColor = .hexToColor(hexString: "#2FD566")
    static let customOrange: UIColor = .hexToColor(hexString: "#FF5800")
    static let customRed: UIColor = .hexToColor(hexString: "#E3212F")
    
    // Set of all Secondary Color Options
    static let colors = [ColorOptions.purple.rawValue: UIColor.customPurple,
                         ColorOptions.blue.rawValue: UIColor.customBlue,
                         ColorOptions.green.rawValue: UIColor.customGreen,
                         ColorOptions.orange.rawValue: UIColor.customOrange,
                         ColorOptions.red.rawValue: UIColor.customRed]
    
    // Secondary Color used throughout Application
    static var secondaryColor = UIColor.colors.randomElement()?.value ?? UIColor.blue
}
