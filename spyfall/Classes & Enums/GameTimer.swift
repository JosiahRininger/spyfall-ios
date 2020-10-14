//
//  GameTimer.swift
//  spyfall
//
//  Created by Josiah Rininger on 7/26/20.
//  Copyright © 2020 Josiah Rininger. All rights reserved.
//

import Foundation

protocol GameTimerDelegate: class {
    func updateTimerLabel(with timeLeft: TimeInterval)
    func timerFinished()
}

class GameTimer {
    private weak var delegate: GameTimerDelegate?
    private var timer = Timer()
    private var currentTimeLeft: TimeInterval = 0.0
    private var maxTimeInterval: TimeInterval = 0.0
    private var isInvalidated = false
    
    init(delegate: GameTimerDelegate, timeLimit: Int) {
        self.delegate = delegate
        maxTimeInterval = TimeInterval(timeLimit * 60)
        currentTimeLeft = maxTimeInterval
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTriggered()
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    private func timerTriggered() {
        guard !isInvalidated else { return }

        switch currentTimeLeft {
        case let x where x > 0:
            currentTimeLeft -= 1
            delegate?.updateTimerLabel(with: currentTimeLeft)
        default:
            delegate?.timerFinished()
            timer.invalidate()
            isInvalidated = true
        }
    }
}
