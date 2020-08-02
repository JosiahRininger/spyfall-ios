//
//  SettingsViewModel.swift
//  SpyfallFree
//
//  Created by Josiah Rininger on 7/23/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit
import FirebaseFirestore
import os.log

protocol SettingsViewModelDelegate: class {
    var selectedColor: UIColor { get set }
}

class SettingsViewModel {
    weak var delegate: SettingsViewModelDelegate?
    
    // MARK: - Public Methods
    @discardableResult
    func retrieveSavedColor() -> UIColor {
        guard let colorString = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.secondaryColor) as? String,
            let delegate = delegate else { return UIColor.clear }
        switch colorString {
        case ColorOptions.purple.rawValue: delegate.selectedColor = .customPurple
        case ColorOptions.blue.rawValue: delegate.selectedColor = .customBlue
        case ColorOptions.green.rawValue: delegate.selectedColor = .customGreen
        case ColorOptions.orange.rawValue: delegate.selectedColor = .customOrange
        case ColorOptions.red.rawValue: delegate.selectedColor = .customRed
        case ColorOptions.random.rawValue: delegate.selectedColor = .secondaryBackgroundColor; return UIColor.colors.randomElement()?.value ?? UIColor.blue
        default: return UIColor.colors.randomElement()?.value ?? UIColor.blue
        }
        return delegate.selectedColor
    }
    
    func setUserDefaultsColor() {
        guard let delegate = delegate else { return }
        switch delegate.selectedColor {
        case .customPurple: UserDefaults.standard.set(ColorOptions.purple.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
        case .customBlue: UserDefaults.standard.set(ColorOptions.blue.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
        case .customGreen: UserDefaults.standard.set(ColorOptions.green.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
        case .customOrange: UserDefaults.standard.set(ColorOptions.orange.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
        case .customRed: UserDefaults.standard.set(ColorOptions.red.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
        case .secondaryBackgroundColor: UserDefaults.standard.set(ColorOptions.random.rawValue, forKey: Constants.UserDefaultKeys.secondaryColor)
        default: SpyfallError.unknown.log("Unable to set UserDefault Color")
        }
    }
}
