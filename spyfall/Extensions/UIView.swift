//
//  UIView.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/2/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

extension UIView {
    func addShadowWith(radius: CGFloat, offset: CGSize, opacity: Float) {
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
}
