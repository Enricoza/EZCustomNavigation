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
    
    public static var shouldAvoidLeftBounceBlock: ((UIScrollView)->(Bool))? = { scrollView in
        return scrollView.isDescendantOfClass(EZNavigationController.self)
    }
    
    
    private static let shouldAvoidLeftBounceBlockAssociation = ObjectAssociation<ValueTypeWrapper<ActivationBlock?>>()
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
        if frame.size.width < self.contentSize.width,
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: gestureRecognizer.view)
            if self.contentOffset.x == 0,
                velocity.x > 0,
                abs(velocity.x) > abs(velocity.y) {
                return true
            }
        }
        return false
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isEligibleForAvoidingLeftBounce() && isLeftBounceGesture(gestureRecognizer) {
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}
