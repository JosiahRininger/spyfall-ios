//
//  Game.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

struct Player {
    let role: String
    let username: String
    var votes: Int
    
    func getPlayer() -> [String: Any] {
        let dict = ["role": self.role,
                    "username": self.username,
                    "votes": self.votes
            ] as [String : Any]
        return dict
    }
}
