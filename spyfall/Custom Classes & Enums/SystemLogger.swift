//
//  SystemLogger.swift
//  spyfall
//
//  Created by Josiah Rininger on 10/18/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import UIKit
import os.log

class SystemLogger {
    //  private init()
    
    static let shared = SystemLogger()
    
    var logger: OSLog = {
        return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: "SystemLogger"))
    }()
}
