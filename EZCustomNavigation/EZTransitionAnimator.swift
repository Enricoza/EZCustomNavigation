//
//  EZTransitionAnimator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit



public final class EZTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    let parallaxPercent: CGFloat
    let duration: TimeInterval
    
    public init(presenting: Bool, parallaxPercent: CGFloat = 0.25, duration: TimeInterval? = nil) {
        self.presenting = presenting
        self.parallaxPercent = parallaxPercent
        self.duration = duration ?? TimeInterval(UINavigationController.hideShowBarDuration)
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

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

        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        toView.frame = fromView.frame
                        fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width*self.parallaxPercent : fromView.frame.width,
                                                y: fromView.frame.origin.y,
                                    width: fromView.frame.width,
                                    height: fromView.frame.height)
        }) { (finished) in
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
