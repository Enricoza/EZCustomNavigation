//
//  UIPanGestureRecognizer+MainDirection.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 12/01/2021.
//

import Foundation



extension UIPanGestureRecognizer {
    
    enum Direction {
        case top
        case left
        case down
        case right
    }
    
    func currentMainDirection() -> Direction? {
        guard let view = self.view else {
            return nil
        }
        let vel = self.velocity(in: view)
        let isHorizontal = abs(vel.x) > abs(vel.y)
        if (isHorizontal) {
            return vel.x > 0 ? .right : .left
        } else {
            return vel.y > 0 ? .down : .top
        }
    }
    
    
}
