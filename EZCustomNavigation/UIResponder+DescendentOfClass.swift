//
//  File.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 02/11/2019.
//

import UIKit


extension UIResponder {
    
    /**
     * Returns true if aClass is one of self next responders
     *
     * - parameter aClass: The class to which we are testing the responders
     */
    public func isDescendantOfClass(_ aClass: AnyClass) -> Bool {
        if self.isKind(of: aClass) {
            return true
        }
        if let next = self.next {
            return next.isDescendantOfClass(aClass)
        }
        return false
    }
    
}


