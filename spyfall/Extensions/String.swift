//
//  String.swift
//  spyfall
//
//  Created by Seth Rininger on 8/27/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit

extension String {
    func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
