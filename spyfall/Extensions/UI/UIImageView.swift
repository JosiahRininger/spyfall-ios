//
//  UIImageView.swift
//  spyfall
//
//  Created by Josiah Rininger on 8/26/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
