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
        let factor = velocity / Constants.Velocity.scale
        return min(max(Constants.Velocity.factorLimitBottom, abs(factor)), Constants.Velocity.factorLimitTop)
    }
    
    private func defaultCompletionSpeed(progress: CGFloat) -> CGFloat {
        1
    }
}
