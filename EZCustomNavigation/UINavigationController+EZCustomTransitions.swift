//
//  UINavigationController+EZCustomTransitions.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit




extension UINavigationController {
    
    
    private static let association = ObjectAssociation<EZNavigationControllerTransitionHelper>()
    private var transitionCoordinatorHelper: EZNavigationControllerTransitionHelper? {

        get { return UINavigationController.association[self] }
        set { UINavigationController.association[self] =  newValue}
    }
    
    /**
     * Add custom transitioning to this navigation controller.
     *
     * - parameter transitionHelper: The helper class that adds gesture to this navigation controller and informs It's coordinator of interaction events
     * - parameter onShouldPopViewController: A block called when the helper class wants to pop the view controller. You should pop the view controller when this method is called and, if you do, you must return true
     */
    public func addCustomTransitioning(_ transitionHelper: EZNavigationControllerTransitionHelper = EZNavigationControllerTransitionHelper(), onShouldPopViewController: (()->(Bool))? = nil) {
        guard transitionCoordinatorHelper == nil else {
            return
        }
        transitionCoordinatorHelper = transitionHelper
        delegate = transitionHelper.navigationControllerDelegate
        let onShouldPopViewController = onShouldPopViewController ?? { [weak self] () -> (Bool) in
            guard let self = self, self.viewControllers.count > 1 else {
                return false
                
            }
            self.popViewController(animated: true)
            return true
        }
        transitionHelper.attachDismissGestures(to: self, onShouldPopViewController: onShouldPopViewController)
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
            transitionCoordinatorHelper = nil
        }
    }
    
    
}
