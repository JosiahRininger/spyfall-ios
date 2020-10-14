//
//  DispatchQueue.swift
//  spyfall
//
//  Created by Josiah Rininger on 1/12/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, workItem: DispatchWorkItem) {
        DispatchQueue.global(qos: .background).async {
            background?()
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    workItem.perform()
            }
        }
    }
}
