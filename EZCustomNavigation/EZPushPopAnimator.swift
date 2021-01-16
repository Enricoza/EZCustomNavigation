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
     * - parameter duration: The duration of the animation. Default to 0.33
     */
    public init(presenting: Bool, parallaxPercent: CGFloat = 0.25, duration: TimeInterval = 0.33) {
        self.presenting = presenting
        self.parallaxPercent = parallaxPercent
        self.duration = duration
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
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
        let dimmingView = UIView(frame: container.frame)
        dimmingView.backgroundColor = UIColor.black
        let maxDimmingViewAlpha: CGFloat = 0.1
        let startingX: CGFloat
        if presenting {
            container.addSubview(dimmingView)
            container.addSubview(toView)
            dimmingView.alpha = 0
            startingX = toView.frame.width
        } else {
            container.insertSubview(toView, belowSubview: fromView)
            container.insertSubview(dimmingView, belowSubview: fromView)
            dimmingView.alpha = maxDimmingViewAlpha
            startingX = -toView.frame.width*self.parallaxPercent
            
        }
        toView.frame = CGRect(x: startingX,
                              y: toView.frame.origin.y,
                              width: toView.frame.width,
                              height: toView.frame.height)

        self.isAnimating = true
        let animationBlock = {
            let finalX: CGFloat
            if (self.presenting) {
                finalX = -fromView.frame.width*self.parallaxPercent
                dimmingView.alpha = maxDimmingViewAlpha
            } else {
                finalX = fromView.frame.width
                dimmingView.alpha = 0
            }
            toView.frame = transitionContext.finalFrame(for: toVC)
            fromView.frame = CGRect(x: finalX,
                                    y: fromView.frame.origin.y,
                                    width: fromView.frame.width,
                                    height: fromView.frame.height)
        }
        let completionBlock = {(finished: Bool) in
            container.addSubview(toView)
            dimmingView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.isAnimating = false
        }
        
        if (transitionContext.isInteractive) {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveLinear,
                           animations: animationBlock,
                           completion: completionBlock)
        } else {
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    options: .calculationModeCubic,
                                    animations: animationBlock,
                                    completion: completionBlock)
        }
        
    }
}
