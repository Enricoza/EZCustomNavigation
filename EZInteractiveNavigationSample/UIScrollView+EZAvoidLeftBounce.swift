//
//  UIScrollView+EZAvoidLeftBounce.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    
    private static let association = ObjectAssociation<NSNumber>()

    public var shouldAvoidLeftBounce: Bool {

        get { return UIScrollView.association[self]?.boolValue ?? false }
        set { UIScrollView.association[self] = NSNumber(booleanLiteral: newValue) }
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if shouldAvoidLeftBounce,
            self.visibleSize.width < self.contentSize.width,
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: gestureRecognizer.view)
            if self.contentOffset.x == 0,
                velocity.x > 0,
                abs(velocity.x) > abs(velocity.y) {
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}



