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
     * Override the onShouldPopViewController method to change its behavior.
     *
     * - parameter transitionHelper: The helper class that adds gesture to this navigation controller and informs It's coordinator of interaction events
     */
    public func addCustomTransitioning(_ transitionHelper: EZNavigationControllerTransitionHelper = EZNavigationControllerTransitionHelper()) {
        _addCustomTransitioning(transitionHelper, onShouldPopViewController: nil)
    }

    /**
     * Add custom transitioning to this navigation controller.
     *
     * - WARNING: Deprecated. Use addCustomTransitioning with the single helper parameter. Override the onShouldPopViewController method to change it's behavior
     *
     * - parameter transitionHelper: The helper class that adds gesture to this navigation controller and informs It's coordinator of interaction events
     * - parameter onShouldPopViewController: A block called when the helper class wants to pop the view controller. You should pop the view controller when this method is called and, if you do, you must return true
     */
    @available(*, deprecated, message: "Deprecated in favor of addCustomTransitioning with the single helper parameter. Override the onShouldPopViewController method to change it's behavior if needed.")
    public func addCustomTransitioning(_ transitionHelper: EZNavigationControllerTransitionHelper = EZNavigationControllerTransitionHelper(),
                                       onShouldPopViewController: (()->(Bool))?) {
        _addCustomTransitioning(transitionHelper, onShouldPopViewController: onShouldPopViewController)
    }
    
    private func _addCustomTransitioning(_ transitionHelper: EZNavigationControllerTransitionHelper = EZNavigationControllerTransitionHelper(),
                                       onShouldPopViewController: (()->(Bool))?) {
        guard transitionCoordinatorHelper == nil else {
            return
        }
        transitionCoordinatorHelper = transitionHelper
        delegate = transitionHelper.navigationControllerDelegate
        let onShouldPopViewController = onShouldPopViewController ?? { [weak self] () -> (Bool) in
            return self?.onShouldPopViewController() == true
        }
        transitionHelper.attachDismissGestures(to: self, onShouldPopViewController: onShouldPopViewController)
        
        guard let unpopConfig = transitionHelper.configuration.unpopConfiguration else {
            return
        }
        UINavigationController.classInit
        self.unpopStack = UnpopStack(config: unpopConfig)
        let onShouldUnpopViewController = { [weak self] () -> (Bool) in
            return self?.onShouldUnpopViewController() == true
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
    
    @objc open func onShouldPopViewController() -> Bool {
        self.popViewController(animated: true)
        return true
    }
    
    @objc open func onShouldUnpopViewController() -> Bool {
        guard let vc = unpopStack?.pop() else {
            return false
        }
        
        swizzled_pushViewController(vc, animated: true)
        
        onAnimationCompletion { (success) in
            if !success {
                self.unpopStack?.push(vc)
            }
        }
        return true
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
