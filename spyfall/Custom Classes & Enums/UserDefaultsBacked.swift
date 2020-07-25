//
//  UserDefaultsBacked.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/24/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Foundation

@propertyWrapper struct Capitalized {
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}

