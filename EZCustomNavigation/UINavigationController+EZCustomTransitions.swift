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
    
    
    public func addCustomTransitioning(_ transitionHelper: EZNavigationControllerTransitionHelper = EZNavigationControllerTransitionHelper(), onShouldPopViewController: (()->(Bool))? = nil) {
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
    }
    
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
