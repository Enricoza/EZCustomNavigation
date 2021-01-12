//
//  UIScrollView+EZAvoidLeftBounce.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    public typealias ActivationBlock = ()->(Bool)
    
    /**
     * A block called when left bounce on a horizontally-scrollable scrollview wants to start a left bounce.
     *
     * You can make your own logic for the scrollView passed inside this method.
     * Return true to avoid left bounce and start a Pan-to-pop animation instead. Return false if you want the scrollView scroll to be prioritized over the Pan-to-pop.
     *
     * Make sure that the scrollView is inside a Pan-to-pop enabled NavigationController or blocking this left bounce scroll will serve no purpose.
     *
     * The default implementation returns true if the scrollView is embedded inside a EZNavigationController.
     */
    public static var shouldAvoidLeftBounceBlock: ((UIScrollView)->(Bool))? = { scrollView in
        return scrollView.isDescendantOfClass(EZNavigationController.self)
    }
    
    
    private static let shouldAvoidLeftBounceBlockAssociation = ObjectAssociation<ValueTypeWrapper<ActivationBlock?>>()
    
    /**
     * A block called when this scrollView is horizontally scrollable and wants to start a left bounce scroll.
     *
     * Provide this block to override the generic static one for this specific scrollView.
     * Return true to avoid left bounce and start a Pan-to-pop animation instead. Return false if you want the scrollView scroll to be prioritized over the Pan-to-pop.
     *
     * This is nil by default (meaning that if you don't provide your specific implementation only the static one will be taken in consideration)
     */
    public var shouldAvoidLeftBounceBlock: (ActivationBlock)? {
        get { return UIScrollView.shouldAvoidLeftBounceBlockAssociation[self]?.any }
        set { UIScrollView.shouldAvoidLeftBounceBlockAssociation[self] = ValueTypeWrapper(newValue) }
    }
    
    private func isEligibleForAvoidingLeftBounce() -> Bool {
        if let block = self.shouldAvoidLeftBounceBlock {
            return block()
        }
        return UIScrollView.shouldAvoidLeftBounceBlock?(self) == true
    }
    
    private func isLeftBounceGesture(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer,
            frame.size.width < self.contentSize.width,
            self.contentOffset.x == 0,
            panGesture.currentMainDirection() == .right {
            return true
        }
        return false
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isLeftBounceGesture(gestureRecognizer) && isEligibleForAvoidingLeftBounce() {
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}
