//
//  SpeedCalculator.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 09/01/22.
//

import Foundation

struct SpeedCalculator {
    let duration: CGFloat
    
    func completionSpeed(progress: CGFloat, velocity: CGFloat) -> CGFloat {
        defaultCompletionSpeed(progress: progress) * velocityFactor(velocity: velocity)
    }
    
    private func velocityFactor(velocity: CGFloat) -> CGFloat {
        let factor = velocity / 300
        return min(max(1, abs(factor)),3)
    }
    
    private func defaultCompletionSpeed(progress: CGFloat) -> CGFloat {
        (1 - abs(progress))
    }
}
