//
//  UINavigationController+SwizzledPushAndPop.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 27/09/2020.
//

import Foundation


private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension UINavigationController {
    
    static let classInit: Void = {
        UINavigationController.swizzlePush()
        UINavigationController.swizzlePop()
    }()
    
    private static func swizzlePush() {
        let originalSelector = #selector(pushViewController(_:animated:))
        let swizzledSelector = #selector(swizzled_pushViewController(_:animated:))
        swizzling(UINavigationController.self, originalSelector, swizzledSelector)
    }
    
    private static func swizzlePop() {
        let originalSelector = #selector(popViewController(animated:))
        let swizzledSelector = #selector(swizzled_popViewController(animated:))
        swizzling(UINavigationController.self, originalSelector, swizzledSelector)
    }
    
    @objc func swizzled_pushViewController(_ viewController: UIViewController, animated: Bool) {
        swizzled_pushViewController(viewController, animated: animated)
        unpopStack?.clear()
    }
    @objc func swizzled_popViewController(animated: Bool) -> UIViewController? {
        guard let vc = self.swizzled_popViewController(animated: animated) else {
            return nil
        }
        onAnimationCompletion { (success) in
            if (success) {
                self.unpopStack?.push(vc)
            }
        }
        
        return vc
    }
    
}
