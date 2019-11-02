//
//  UIScrollView+EZAvoidLeftBounce.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    
    private static let avoidleftBounceAssociation = ObjectAssociation<NSNumber>()
    public var shouldAvoidLeftBounce: Bool {
        get { return UIScrollView.avoidleftBounceAssociation[self]?.boolValue ?? false }
        set { UIScrollView.avoidleftBounceAssociation[self] = NSNumber(booleanLiteral: newValue) }
    }
    
    private static let forceLeftBounceAssociation = ObjectAssociation<NSNumber>()
    public var forceLeftBounceActive: Bool {
        get { return UIScrollView.forceLeftBounceAssociation[self]?.boolValue ?? false }
        set { UIScrollView.forceLeftBounceAssociation[self] = NSNumber(booleanLiteral: newValue) }
    }
    
    static var shouldAvoidLeftBounceBlock: ((UIScrollView)->(Bool))?
    
    private func isEligibleForAvoidingLeftBounce() -> Bool {
        return !forceLeftBounceActive && (shouldAvoidLeftBounce || UIScrollView.shouldAvoidLeftBounceBlock?(self) == true)
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



