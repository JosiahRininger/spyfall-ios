//
//  AddSubview.swift
//  spyfall
//
//  Created by Josiah Rininger on 6/20/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
