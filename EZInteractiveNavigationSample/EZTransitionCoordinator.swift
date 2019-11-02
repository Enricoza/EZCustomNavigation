//
//  EZTransitionCoordinator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit






final class EZTransitionCoordinator: NSObject {
    
    enum InteractiveAnimationEvent {
        /// Must be called before the actual pop of the view controller
        case willStart
        case didUpdate(progress: CGFloat)
        case didComplete
        case didCancel
    }
    
    
    private let interactionController: UIPercentDrivenInteractiveTransition
    private var onGoingInteractiveTransition = false

    
    init(interactionController: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()) {
        self.interactionController = interactionController
    }
    
    func onInteractiveTransitionEvent(_ event: InteractiveAnimationEvent) {
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
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return EZTransitionAnimator(presenting: true)
        case .pop:
            return EZTransitionAnimator(presenting: false)
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard onGoingInteractiveTransition else {
            return nil
        }
        return interactionController
    }
    
}




