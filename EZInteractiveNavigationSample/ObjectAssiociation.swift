//
//  ObjectAssiociation.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import Foundation


final class ObjectAssociation<T: AnyObject> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    subscript(index: AnyObject) -> T? {

        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
