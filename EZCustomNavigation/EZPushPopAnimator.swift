//
//  EZTransitionAnimator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit

/**
 * A protocol used to inform on whether an animation is ongoing or not.
 */
public protocol EZAnimating {
    var isAnimating: Bool { get }
}

/**
 * A simple custom implementation of the default animation of a navigation controller
 */
public final class EZPushPopAnimator: NSObject, UIViewControllerAnimatedTransitioning, EZAnimating {
    
    let presenting: Bool
    let parallaxPercent: CGFloat
    let duration: TimeInterval
    public private(set) var isAnimating: Bool = false
    
    /**
     * Creates the animator
     *
     * - parameter presenting: If this animator handles presenting or dismissing animations
     * - parameter parallaxPercent: The percentage of the parallax effect to the back view controller. 0 means it's still, 1 means it moves side by side with the top one. Defaults to 0.25
     * - parameter duration: The duration of the animation. Default to `UINavigationController.hideShowBarDuration`
     */
    public init(presenting: Bool, parallaxPercent: CGFloat = 0.25, duration: TimeInterval? = nil) {
        self.presenting = presenting
        self.parallaxPercent = parallaxPercent
        self.duration = duration ?? TimeInterval(UINavigationController.hideShowBarDuration)
    }

    /**
     * Returns the duration of the transition
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    /**
     * Animates the transition between the two view controllers
     */
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width*self.parallaxPercent,
                              y: toView.frame.origin.y,
                              width: toView.frame.width,
                              height: toView.frame.height)

        self.isAnimating = true
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: transitionContext.isInteractive ? .curveLinear : .curveEaseInOut,
                       animations: {
                        toView.frame = fromView.frame
                        fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width*self.parallaxPercent : fromView.frame.width,
                                                y: fromView.frame.origin.y,
                                    width: fromView.frame.width,
                                    height: fromView.frame.height)
        }) { (finished) in
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.isAnimating = false
        }
    }
}
