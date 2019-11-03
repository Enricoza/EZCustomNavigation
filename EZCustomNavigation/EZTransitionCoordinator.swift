//
//  EZTransitionCoordinator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit



open class EZTransitionCoordinator: NSObject {
    
    public enum InteractiveAnimationEvent {
        /// Must be called before the actual pop of the view controller
        case willStart
        case didUpdate(progress: CGFloat)
        case didComplete
        case didCancel
    }
    
    
    private let interactionController: UIPercentDrivenInteractiveTransition
    private let presentingAnimator: UIViewControllerAnimatedTransitioning
    private let dismissingAnimator: UIViewControllerAnimatedTransitioning
    private var onGoingInteractiveTransition = false

    
    public init(presentingAnimator: UIViewControllerAnimatedTransitioning = EZPushPopAnimator(presenting: true),
                dismissingAnimator: UIViewControllerAnimatedTransitioning = EZPushPopAnimator(presenting: false),
                interactionController: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()) {
        self.presentingAnimator = presentingAnimator
        self.dismissingAnimator = dismissingAnimator
        self.interactionController = interactionController
    }
    
    open func onInteractiveTransitionEvent(_ event: InteractiveAnimationEvent) {
        switch event {
        case .willStart:
            self.onGoingInteractiveTransition = true
        case .didUpdate(let progress):
            self.interactionController.update(progress)
        case .didComplete:
            self.interactionController.finish()
            self.onGoingInteractiveTransition = false
        case .didCancel:
            self.interactionController.cancel()
            self.onGoingInteractiveTransition = false
        }
        
    }

}



extension EZTransitionCoordinator: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return self.presentingAnimator
        case .pop:
            return self.dismissingAnimator
        default:
            return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard onGoingInteractiveTransition else {
            return nil
        }
        return interactionController
    }
    
}


