//
//  GameDataValidity.swift
//  spyfall
//
//  Created by Josiah Rininger on 12/30/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

enum GameDataValidity {
    case accessCodeIsEmpty
    case usernameIsEmpty
    case gameDoesNotExist
    case usernameIsTaken
    case gameHasAlreadyStarted
    case playersAreFull
    case AllFieldsAreValid
}
