//
//  UnpopStack.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 26/09/2020.
//

import Foundation

class UnpopStack {
    
    let config: EZUnpopConfiguration
    private var stack: [UIViewController] = []
    var count: Int {
        return stack.count
    }
    let debouncer: EZDebouncer?
    
    init(config: EZUnpopConfiguration) {
        self.config = config
        if let ttl = config.ttl {
            self.debouncer = EZDebouncer(interval: ttl)
            debouncer?.callback = { [weak self] in
                self?.clear()
            }
        } else {
            self.debouncer = nil
        }
    }
    
    func push(_ vc: UIViewController) {
        if stack.count >= config.stackDepth {
            stack.removeFirst()
        }
        debouncer?.call()
        stack.append(vc)
    }
    
    func pop() -> UIViewController {
        debouncer?.call()
        return stack.removeLast()
    }
    
    func clear() {
        stack.removeAll()
    }
}
