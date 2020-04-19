//
//  IDs.swift
//  spyfall
//
//  Created by Josiah Rininger on 8/26/19.
//  Copyright © 2019 Josiah Rininger. All rights reserved.
//

import Foundation

extension Constants {
    /// IDs used throughout the app
    struct IDs {
        static let playerListCellId = "playerListCellId"
        static let playersCollectionViewCellId = "playersCollectionViewCellId"
        static let locationsCollectionViewCellId = "locationsCollectionViewCellId"
        static let colorsCollectionViewCellId = "colorsCollectionViewCellId"
        static let appStoreLinkURL = "https://itunes.apple.com/us/app/apple-store/id1501939797?mt=8"
        
#if DEBUG
        static let waitingScreenPladementID = "ca-app-pub-3940256099942544/2934735716"
        static let gameSessionAdUnitID = "ca-app-pub-3940256099942544/2934735716"
#else
        static let waitingScreenAdUnitID = "540161866691831_540165053358179"
        static let gameSessionAdUnitID = "ca-app-pub-6687613409331343/4405950965"
#endif
    }
}
