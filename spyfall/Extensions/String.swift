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
    
    static func timerFormat(timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}
