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
    
    static func hexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static let primaryWhite: UIColor = .hexToColor(hexString: "#FCFCFC")
    static let secondaryColor: UIColor = .hexToColor(hexString: "#D65656")
    static let primaryGray: UIColor = .hexToColor(hexString: "#707070")
    static let textGray: UIColor = .hexToColor(hexString: "#585858")
    static let packOneColor: UIColor = .hexToColor(hexString: "#88C3BA")
    static let packTwoColor: UIColor = .hexToColor(hexString: "#CC9369")
    static let specialPackColor: UIColor = .hexToColor(hexString: "#C388B3")
    static let tableViewCellGray: UIColor = .hexToColor(hexString: "#F4F4F4")

}
