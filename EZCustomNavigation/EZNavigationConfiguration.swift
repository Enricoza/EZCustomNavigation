//
//  EZNavigationConfiguration.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 27/09/2020.
//

import Foundation

public struct EZNavigationConfiguration {
    let unpopConfiguration: EZUnpopConfiguration?
    
    public init(unpop: EZUnpopConfiguration? = EZUnpopConfiguration()) {
        self.unpopConfiguration = unpop
    }
}

public struct EZUnpopConfiguration {
    let ttl: TimeInterval?
    let stackDepth: Int
    
    public init(ttl: TimeInterval? = nil, stackDepth: Int = 3) {
        self.ttl = ttl
        self.stackDepth = stackDepth
    }
}
