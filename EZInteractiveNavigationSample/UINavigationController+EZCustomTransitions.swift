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
    
    
    public func addCustomTransitioning() {
        guard transitionCoordinatorHelper == nil else {
            return
        }
        transitionCoordinatorHelper = EZNavigationControllerTransitionHelper()
        delegate = transitionCoordinatorHelper?.navigationControllerDelegate
        transitionCoordinatorHelper?.attachDismissGestures(to: self) { [weak self] () -> (Bool) in
            self?.popViewController(animated: true)
            return true
        }
        
    }
    
    public func removeCustomTransitioning() {
        delegate = nil
        transitionCoordinatorHelper?.detachDismissGestures()
        transitionCoordinatorHelper = nil
    }
    
    
}
