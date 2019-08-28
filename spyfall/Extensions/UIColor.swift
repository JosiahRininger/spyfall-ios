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
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static let primaryWhite: UIColor = .hexToColor(hexString: "#FCFCFC")
    static let secondaryGray: UIColor = .hexToColor(hexString: "#707070")
    static let textGray: UIColor = .hexToColor(hexString: "#585858")
    static let packOneColor: UIColor = .hexToColor(hexString: "#88C3BA")
    static let packTwoColor: UIColor = .hexToColor(hexString: "#CC9369")
    static let specialPackColor: UIColor = .hexToColor(hexString: "#C388B3")
    static let cellGray: UIColor = .hexToColor(hexString: "#F0F0F0")
    
    // Secondary Color Options
    static let customPurple: UIColor = .hexToColor(hexString: "#9533C7")
    static let customBlue: UIColor = .hexToColor(hexString: "#00A0EF")
    static let customGreen: UIColor = .hexToColor(hexString: "#2FD566")
    static let customOrange: UIColor = .hexToColor(hexString: "#FF5800")
    static let customRed: UIColor = .hexToColor(hexString: "#E3212F")
    
    // Set of all Secondary Color Options
    static let colorSet: Set = [UIColor.customPurple,
                                UIColor.customBlue,
                                UIColor.customGreen,
                                UIColor.customOrange,
                                UIColor.customRed]
    
    // Secondary Color used throughout Application
    static let secondaryColor: UIColor = UIColor.colorSet.randomElement() ?? UIColor.blue
}

//
//import UIKit
//typealias ACTION = (() -> ())?
//
////final such that swift compiler doesnt use dynamic dispatch, performance increase
//final class ActionButton: UIButton {
//
//    var action: ACTION = nil
//    var callback: ((Bool) -> ())?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupButton()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupButton()
//    }
//
//    func setupButton() {
//        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
//        setShadow()
//        setTitleColor(UIColor.white, for: .normal)
//        backgroundColor = UIColor.blue
//        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
//    }
//
//    @objc
//    func handleAction() {
//        action?()
//    }
//
//    //    @objc
//    //    func handleActionTwo() {
//    //        callback?(true)
//    //    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //have to set this here as the height is not known until this callback
//        layer.cornerRadius = bounds.height / 2.0
//    }
//
//    private func setShadow() {
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        layer.shadowRadius = 8
//        layer.shadowOpacity = 0.5
//        clipsToBounds = true
//        layer.masksToBounds = false
//    }
//}
