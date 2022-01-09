//
//  EZNavigationControllerTransitionHelper+HandlePanGesture.swift
//  EZCustomNavigation
//
//  Created by Enrico Zannini on 27/09/2020.
//

import Foundation


extension EZNavigationControllerTransitionHelper {
    @objc func handlePopSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        handleGestureRecognizer(gestureRecognizer, forPop: true)
    }
    
    @objc func handleUnpopSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        handleGestureRecognizer(gestureRecognizer, forPop: false)
    }
    
    private func handleGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer, forPop: Bool) {
        guard let gestureRecognizerView = gestureRecognizer.view,
            enableFollowingGesturesWhileAnimating || !coordinator.onGoingAnimation else {
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        let velocity = gestureRecognizer.velocity(in: gestureRecognizerView).x
        onInteractiveGestureRecongnizerState(gestureRecognizer.state,
                                             percent: forPop ? percent : -percent,
                                             velocity: forPop ? velocity : -velocity,
                                             onShouldActivate: forPop ? self.onShouldPopViewController : self.onShouldUnpopViewController)
        
    }
    
    private func onInteractiveGestureRecongnizerState(_ state: UIGestureRecognizer.State, percent: CGFloat, velocity: CGFloat, onShouldActivate: (() -> (Bool))?) {
        switch state {
        case .began:
            enableFollowingGesturesWhileAnimating = true
            self.coordinator.onInteractiveTransitionEvent(.willStart)
            if onShouldActivate?() == false {
                self.coordinator.onInteractiveTransitionEvent(.didCancel(progress: percent, velocity: velocity))
            }
        case .changed:
            self.coordinator.onInteractiveTransitionEvent(.didUpdate(progress: percent))
        case .ended where
                (isTranslationSlow(velocity: velocity) && percent > Constants.percentTranslationLimit)
                || velocity > Constants.Velocity.staleLimit:
            enableFollowingGesturesWhileAnimating = false
            self.coordinator.onInteractiveTransitionEvent(.didComplete(progress: percent, velocity: velocity))
        case .ended, .cancelled:
            enableFollowingGesturesWhileAnimating = false
            self.coordinator.onInteractiveTransitionEvent(.didCancel(progress: percent, velocity: velocity))
        default: ()
        }
    }
    
    private func isTranslationSlow(velocity: CGFloat) -> Bool {
        Constants.Velocity.range.contains(velocity)
    }
}
