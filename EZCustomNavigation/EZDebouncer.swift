//
//  EZDebouncer.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 26/09/2020.
//

import Foundation

class EZDebouncer {
    
    // Callback to be debounced
    // Perform the work you would like to be debounced in this callback.
    var callback: (() -> Void)?
    
    var interval: TimeInterval = 2.0 // Time interval of the debounce window
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    private var timer: EZSafeTimer?
    
    // Indicate that the callback should be called. Begins the debounce window.
    func call() {
        // Invalidate existing timer if there is one
        timer?.invalidate()
        // Begin a new timer from now
        timer = EZSafeTimer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    @objc private func handleTimer(_ timer: Timer) {
        callback?()
    }
    
}
