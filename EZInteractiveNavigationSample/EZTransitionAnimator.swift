//
//  EZTransitionAnimator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit



final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    let parallaxPercent: CGFloat
    init(presenting: Bool, parallaxPercent: CGFloat = 0.25) {
        self.presenting = presenting
        self.parallaxPercent = parallaxPercent
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        let toViewFrame = toView.frame
        toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width*self.parallaxPercent, y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)

        let animations = {
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
//                toView.alpha = 1
//                if self.presenting {
//                    fromView.alpha = 0
//                }
//            }

//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                toView.frame = toViewFrame
            fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width*self.parallaxPercent : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
                if !self.presenting {
//                    fromView.alpha = 0
                }
//            }
            
        }
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: animations,
                                completion: { finished in
                                    // 8
                                    container.addSubview(toView)
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
