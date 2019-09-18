//
//  UIScrollView.swift
//  spyfall
//
//  Created by Josiah Rininger on 9/16/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
