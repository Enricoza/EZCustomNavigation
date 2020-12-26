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
        onInteractiveGestureRecongnizerState(gestureRecognizer.state,
                                             percent: forPop ? percent : -percent,
                                             onShouldActivate: forPop ? self.onShouldPopViewController : self.onShouldUnpopViewController)
        
    }
    
    private func onInteractiveGestureRecongnizerState(_ state: UIGestureRecognizer.State, percent: CGFloat, onShouldActivate: (() -> (Bool))?) {
        switch state {
        case .began:
            enableFollowingGesturesWhileAnimating = true
            self.coordinator.onInteractiveTransitionEvent(.willStart)
            if onShouldActivate?() == false {
                self.coordinator.onInteractiveTransitionEvent(.didCancel)
            }
        case .changed:
            self.coordinator.onInteractiveTransitionEvent(.didUpdate(progress: percent))
        case .ended where percent > 0.3:
            enableFollowingGesturesWhileAnimating = false
            self.coordinator.onInteractiveTransitionEvent(.didComplete)
        case .ended, .cancelled:
            enableFollowingGesturesWhileAnimating = false
            self.coordinator.onInteractiveTransitionEvent(.didCancel)
        default: ()
        }
    }
}
