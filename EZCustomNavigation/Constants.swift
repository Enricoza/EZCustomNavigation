//
//  Constants.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 09/01/22.
//

import Foundation

enum Constants {
    enum Velocity {
        static let staleLimit: CGFloat = 75
        static let range = -staleLimit..<staleLimit
        static let scale: CGFloat = 300
        static let factorLimitTop: CGFloat = 1.5
        static let factorLimitBottom: CGFloat = 1
    }
    static let percentTranslationLimit: CGFloat = 0.66
}
