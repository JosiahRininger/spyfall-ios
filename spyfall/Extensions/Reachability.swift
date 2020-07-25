//
//  Reachability.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/19/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Reachability

extension Reachability {
    var isConnectedToNetwork: Result<Void, SpyfallError> {
        switch connection {
        case .wifi, .cellular: return Result.success(())
        case .unavailable, .none: return Result.failure(.network)
        }
    }
    
    func listenForNetworkChanges() {
        do {
            try startNotifier()
        } catch {
            SpyfallError.reachabilityNotifier.log()
        }
    }
}
