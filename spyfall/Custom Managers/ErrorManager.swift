//
//  ErrorManager.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/20/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import UIKit
import PKHUD

struct ErrorManager {
    private static var networkErrorPopUp: NetworkErrorPopUpView?
    
    static func setPopUp(_ popUp: NetworkErrorPopUpView) {
        networkErrorPopUp = popUp
        networkErrorPopUp?.isHidden = true
    }
    
    static func showPopUp(for view: UIView) {
        networkErrorPopUp?.networkErrorPopUpView.doneButton.backgroundColor = UIColor.secondaryColor
        view.isUserInteractionEnabled = false
        networkErrorPopUp?.isHidden = false
        
        networkErrorPopUp?.networkErrorPopUpView.doneButton.touchUpInside = {
            view.isUserInteractionEnabled = true
            networkErrorPopUp?.isHidden = true
        }
    }
    
    static func showFlash(with message: String) {
        HUD.dimsBackground = false
        HUD.flash(.label(message), delay: 1.0)
    }
}
