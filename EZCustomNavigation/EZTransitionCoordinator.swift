//
//  EZTransitionCoordinator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit


/**
 * Coordinates animators and interactors
 */
open class EZTransitionCoordinator: NSObject {
    
    /**
     * Events of an interactive transition
     */
    public enum InteractiveTransitionEvent {
        /// Must be called before the actual pop of the view controller
        case willStart
        /// On percent update
        case didUpdate(progress: CGFloat)
        /// On transition complete
        case didComplete
        /// On transition cancel
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
        interactionController.completionSpeed = 0.5
    }
    
    open func onInteractiveTransitionEvent(_ event: InteractiveTransitionEvent) {
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


/**
 * Offers default NavigationController delegate implementation according to it's state
 */
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


