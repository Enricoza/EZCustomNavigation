//
//  EZTransitionCoordinator.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit






final class EZTransitionCoordinator: NSObject, UINavigationControllerDelegate {
    
    enum InteractiveAnimationEvent {
        case started
        case updated(progress: CGFloat)
        case completed
        case cancelled
    }
    
    
    private let interactionController: UIPercentDrivenInteractiveTransition
    private var onGoingInteractiveTransition = false
    
    init(interactionController: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()) {
        self.interactionController = interactionController
    }
    
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
    
    func onInteractiveTransitionEvent(_ event: InteractiveAnimationEvent) {
        switch event {
        case .started:
            onGoingInteractiveTransition = true
        case .updated(let progress):
            interactionController.update(progress)
        case .completed:
            interactionController.finish()
            onGoingInteractiveTransition = false
        case .cancelled:
            interactionController.cancel()
            onGoingInteractiveTransition = false
        }
        
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard onGoingInteractiveTransition else {
            return nil
        }
        return interactionController
    }
}
