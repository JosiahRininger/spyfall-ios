//
//  Game.swift
//  spyfall
//
//  Created by Josiah Rininger on 4/8/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

struct Game {
    let playerList: Dictionary<String, [Player]>
    let timeLimit: Dictionary<String, Int>
}

struct Player {
    let username: Dictionary<String, String>
    let role: Dictionary<String, String>
    var votes: Dictionary<String, Int>
}
