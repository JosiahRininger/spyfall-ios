//
//  CreateAlertController.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation
import UIKit

class CreateAlertController {
    
    func withCancelAction(title: String, message: String) -> UIAlertController {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func withTwoActions(title: String, message: String) -> UIAlertController {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func withNoActions(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        return alertController
    }
    
}
