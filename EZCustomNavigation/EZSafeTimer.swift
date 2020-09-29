//
//  EZSafeTimer.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 26/09/2020.
//

import Foundation


class EZSafeTimer {
    var timer: Timer?
    var holder: TimerHolder
    
    
    class func scheduledTimer(withTimeInterval timeInterval: TimeInterval, repeats: Bool, block: @escaping () ->()) -> EZSafeTimer {
        return EZSafeTimer(timeInterval: timeInterval, repeats: repeats, block: block)
    }
    
    class func scheduledTimer(timeInterval: TimeInterval, target: AnyObject, selector: Selector, userInfo: Any?, repeats: Bool) -> EZSafeTimer {
        return EZSafeTimer(timeInterval: timeInterval, target: target, selector: selector, userInfo: userInfo, repeats: repeats)
    }
    
    private init(timeInterval: TimeInterval, repeats: Bool, block: @escaping ()->()) {
        holder = TimerHolder(block: block)
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: holder, selector: #selector(holder.timerDidFire(_:)), userInfo: nil, repeats: repeats)
    }
    
    private init(timeInterval: TimeInterval, target: AnyObject, selector: Selector, userInfo: Any?, repeats: Bool) {
        holder = TimerHolder(target:target, selector: selector)
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: holder, selector: #selector(holder.timerDidFire(_:)), userInfo: userInfo, repeats: repeats)
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        invalidate()
    }
    
}


class TimerHolder: NSObject {
    private weak var target: AnyObject?
    private var selector: Selector?
    private var block: (()->())?
    
    init(target: AnyObject, selector: Selector) {
        self.selector = selector
        self.target = target
    }
    
    init(block: @escaping (()->())) {
        self.block = block
    }

    
    @objc func timerDidFire(_ timer: Timer){
       _ = target?.perform(selector, with: timer)
        self.block?()
    }
    
    
}
