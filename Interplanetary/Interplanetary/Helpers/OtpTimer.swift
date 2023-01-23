//
//  OtpTimer.swift
//  Interplanetary
//
//  Created by Ata Anıl Turgay on 20.01.2023.
//

import Foundation

protocol OTPTimerDelegate: AnyObject {
    
    func timerDidFinish()
    func countDown(_ currentValue: Double)
}

final class OTPTimer {
    
    private weak var timer: Timer?
    weak var delegate: OTPTimerDelegate?
    
    var expiredInSeconds: Double
    init(expiredInSeconds: Double) {
        self.expiredInSeconds = TimeInterval(exactly: expiredInSeconds) ?? Double()
    }
    
    deinit {
        invalidate()
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.tolerance = 0.1
    }
    
    func stop() {
        if timer != nil {
            timer?.invalidate()
        }
    }
    
    func invalidate() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func countDown() {
        if expiredInSeconds.isEqual(to: Double()) {
            delegate?.timerDidFinish()
            return
        }
        if expiredInSeconds < 0 {
            delegate?.timerDidFinish()
            return
        }
        delegate?.countDown(expiredInSeconds)
        expiredInSeconds -= 1
    }
}
