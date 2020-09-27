//
//  EZNavigationConfiguration.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 27/09/2020.
//

import Foundation

/**
 * The configuration for the custom transitioning behavior.
 *
 * If an unpop configuration is passed, than the unpop behavior is activated for this navigation controller.
 */
public struct EZNavigationConfiguration {
    let unpopConfiguration: EZUnpopConfiguration?
    
    /**
     * Creates and returns a new configuration
     */
    public init(unpop: EZUnpopConfiguration? = nil) {
        self.unpopConfiguration = unpop
    }
}

/**
 * The configuration for the unpop behavior
 */
public struct EZUnpopConfiguration {
    let ttl: TimeInterval?
    let stackDepth: Int
    
    /**
     * Creates and returns a new configuration
     *
     * - parameter ttl: The time to leave for the unpop stack. After a push or pop operation on the stack, a clear operation is scheduled for the ttl time. Once the ttl time has passed the whole stack is cleared, freeing memory and stopping further unpop operations for the past view controllers.
     * - parameter stackDepth: The maximum amount of popped view controllers to save inside the unpop stack. Adding other view controller to the stack will remove the oldest view controllers.
     */
    public init(ttl: TimeInterval? = nil, stackDepth: Int = 3) {
        self.ttl = ttl
        self.stackDepth = stackDepth
    }
}
