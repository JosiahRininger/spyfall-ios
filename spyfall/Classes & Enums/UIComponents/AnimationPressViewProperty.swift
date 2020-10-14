//
//  AnimationPressViewProperty.swift
//  spyfall
//
//  Created by Josiah Rininger on 10/13/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//
//  Implementation of this file is inspired from https://github.com/iamazhar/spotify-home
//

import UIKit

/// Enumeration for cell press animation properties.
public enum AnimationPressViewProperty: String {

    case touchDownDuration
    case touchDownScale
    case delay
    case damping
    case velocity
    
    var value: CGFloat {
        switch self {
        case .touchDownDuration: return 0.25
        case .touchDownScale: return 0.965
        case .delay: return 0.0
        case .damping: return 0.9
        case .velocity: return 0.4
        }
    }

}
