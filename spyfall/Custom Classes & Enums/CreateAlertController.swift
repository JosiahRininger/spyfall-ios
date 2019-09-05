//
//  CreateAlertController.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/17/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

class CreateAlertController {
    func with(title: String = "", message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: UIAlertAction...) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alertController.addAction($0) }
        return alertController
    }
}
