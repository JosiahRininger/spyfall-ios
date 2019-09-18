//
//  Encodable.swift
//  spyfall
//
//  Created by Josiah Rininger on 8/26/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

extension Encodable {
    /// Returns a JSON dictionary, with choice of minimal information
    func getDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]
        }
    }
}
