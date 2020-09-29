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
    /**
     * This is the default configuration used by EZNavigationControllerTransitionHelper when no configuration is passed to it's initializer.
     *
     * If you want to override the behavior of all transitionHelper unconditionally, just change this property with your custom configuration prior to creating a EZNavigationControllerTransitionHelper instance (or EZNavigationController)
     *
     * A good place to replace this configuration, should you ever need it, would be in the didFinishLaunchingWithOptions, before the creation of any NavigationController at all.
     */
    public static var defaultConfiguration = EZNavigationConfiguration()
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
     * - parameter ttl: The time to leave for the unpop stack. After a push or pop operation on the stack, a clear operation is scheduled for ttl seconds. Once the ttl seconds have passed the whole stack is cleared, freeing memory and stopping further unpop operations for the past view controllers.
     * - parameter stackDepth: The maximum amount of popped view controllers to save inside the unpop stack. Adding other view controller to the stack will remove the oldest view controllers.
     */
    public init(ttl: TimeInterval? = nil, stackDepth: Int = 3) {
        self.ttl = ttl
        self.stackDepth = stackDepth
    }
}
