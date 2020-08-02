//
//  WorkItemManager.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/23/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

//import Foundation
//
//class WorkItemManager {
//    private var createGameWorkItem: DispatchWorkItem?
//    private var joinGameWorkItem: DispatchWorkItem?
//    private var changeNameWorkItem: DispatchWorkItem?
//    private var startGameWorkItem: DispatchWorkItem?
//    private var endGameWorkItem: DispatchWorkItem?
//
//    private var latestWorkItemType: WorkItemType?
//
//    func setWorkItem(for workItemType: WorkItemType, workItem: DispatchWorkItem) -> Self {
//        latestWorkItemType = workItemType
//        switch workItemType {
//        case .createGame: createGameWorkItem = workItem
//        case .joinGame: joinGameWorkItem = workItem
//        case .changeName: changeNameWorkItem = workItem
//        case .startGame: startGameWorkItem = workItem
//        case .endGame: endGameWorkItem = workItem
//        }
//        return self
//    }
//
//    func executeWorkItem(for workItemType: WorkItemType) {
//        switch workItemType {
//        case .createGame:
//            createGameWorkItem?.perform()
//        case .joinGame:
//            guard let joinGameWorkItem = joinGameWorkItem else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: joinGameWorkItem)
//        case .changeName:
//            guard let changeNameWorkItem = changeNameWorkItem else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: changeNameWorkItem)
//        case .startGame:
//            guard let startGameWorkItem = startGameWorkItem else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: startGameWorkItem)
//        case .endGame:
//            guard let endGameWorkItem = endGameWorkItem else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: endGameWorkItem)
//        }
//    }
//
//    func execute() {
//        guard let latestWorkItemType = latestWorkItemType else { return }
//        executeWorkItem(for: latestWorkItemType)
//    }
//
//    func cancelWorkItem(for workItemType: WorkItemType) {
//        switch workItemType {
//        case .createGame: createGameWorkItem?.cancel()
//        createGameWorkItem?.perform()
//        case .joinGame: joinGameWorkItem?.cancel()
//        case .changeName: changeNameWorkItem?.cancel()
//        case .startGame: startGameWorkItem?.cancel()
//        case .endGame: endGameWorkItem?.cancel()
//        }
//    }
//}
