//
//  UINavigationController+EZCustomTransitions.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    
    private static let transitionHelperAssociation = ObjectAssociation<EZNavigationControllerTransitionHelper>()
    private var transitionCoordinatorHelper: EZNavigationControllerTransitionHelper? {
        get { return UINavigationController.transitionHelperAssociation[self] }
        set { UINavigationController.transitionHelperAssociation[self] = newValue }
    }
    
    private static let unpopStackAssociation = ObjectAssociation<UnpopStack>()
    private(set) var unpopStack: UnpopStack? {
        get { return UINavigationController.unpopStackAssociation[self] }
        set { UINavigationController.unpopStackAssociation[self] = newValue }
    }
    
    /**
     * Add custom transitioning to this navigation controller.
     *
     * - parameter transitionHelper: The helper class that adds gesture to this navigation controller and informs It's coordinator of interaction events
     * - parameter onShouldPopViewController: A block called when the helper class wants to pop the view controller. You should pop the view controller when this method is called and, if you do, you must return true
     */
    public func addCustomTransitioning(_ transitionHelper: EZNavigationControllerTransitionHelper = EZNavigationControllerTransitionHelper(),
                                       onShouldPopViewController: (()->(Bool))? = nil) {
        guard transitionCoordinatorHelper == nil else {
            return
        }
        transitionCoordinatorHelper = transitionHelper
        delegate = transitionHelper.navigationControllerDelegate
        let onShouldPopViewController = onShouldPopViewController ?? { [weak self] () -> (Bool) in
            self?.popViewController(animated: true)
            return true
        }
        transitionHelper.attachDismissGestures(to: self, onShouldPopViewController: onShouldPopViewController)
        
        guard let unpopConfig = transitionHelper.configuration.unpopConfiguration else {
            return
        }
        UINavigationController.classInit
        self.unpopStack = UnpopStack(config: unpopConfig)
        let onShouldUnpopViewController = { [weak self] () -> (Bool) in
            guard let canUnpop = self?.canUnpop(), canUnpop else {
                return false
            }
            self?.unpop()
            return true
        }
        transitionHelper.attachUnpopGesture(to: self, onShouldUnpopViewController: onShouldUnpopViewController)
    }
    
    /**
     * Reset the navigation controller to the default state prior to addCustomTransitioning call
     */
    public func removeCustomTransitioning() {
        if let helper = transitionCoordinatorHelper {
            if delegate === helper.navigationControllerDelegate {
                delegate = nil
            }
            helper.detachDismissGestures()
            helper.detachUnpopGesture()
            transitionCoordinatorHelper = nil
            unpopStack = nil
        }
    }
    
    private func canUnpop() -> Bool {
        return self.unpopStack?.count ?? 0 > 0
    }
    
    private func unpop() {
        guard let vc = self.unpopStack?.pop() else {
            return
        }
        
        self.swizzled_pushViewController(vc, animated: true)
        
        onAnimationCompletion { (success) in
            if !success {
                self.unpopStack?.push(vc)
            }
        }
    }
    
    func onAnimationCompletion(completion: @escaping (Bool)->()) {
        guard let coordinator = transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: nil) { context in
            completion(!context.isCancelled)
        }
    }
}
