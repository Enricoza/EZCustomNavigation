//
//  EZTransitionHelper.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit


public final class EZNavigationControllerTransitionHelper: NSObject {
    
    
    private let coordinator: EZTransitionCoordinator
    private var edgeGesture: UIScreenEdgePanGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var onShouldPopViewController: (()->(Bool))?
    private weak var navigationControllerView: UIView? {
        didSet {
            detachDismissGestures(from: oldValue)
        }
    }
    public var navigationControllerDelegate: UINavigationControllerDelegate {
        return coordinator
    }
    
    public override init() {
        self.coordinator = EZTransitionCoordinator()
    }
    
    public func attachDismissGestures(to navigationController: UINavigationController, onShouldPopViewController: @escaping (()->(Bool))) {
        guard let view = navigationController.view else {
            return
        }
        self.navigationControllerView = view
        self.onShouldPopViewController = onShouldPopViewController
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        edgeSwipeGestureRecognizer.delegate = self
        self.edgeGesture = edgeSwipeGestureRecognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        self.panGesture = panGesture
        view.addGestureRecognizer(panGesture)
    }
    
    public func detachDismissGestures() {
        detachDismissGestures(from: navigationControllerView)
    }
    
    private func detachDismissGestures(from view: UIView?) {
        if let edgeGesture = self.edgeGesture {
            view?.removeGestureRecognizer(edgeGesture)
            self.edgeGesture = nil
        }
        if let panGesture = self.panGesture {
            view?.removeGestureRecognizer(panGesture)
            self.panGesture = nil
        }
        self.onShouldPopViewController = nil
    }
    
    @objc private func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else {
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        switch gestureRecognizer.state {
        case .began:
            self.coordinator.onInteractiveTransitionEvent(.willStart)
            if self.onShouldPopViewController?() == false {
                self.coordinator.onInteractiveTransitionEvent(.didCancel)
            }
        case .changed:
            self.coordinator.onInteractiveTransitionEvent(.didUpdate(progress: percent))
        case .ended where percent > 0.3:
            self.coordinator.onInteractiveTransitionEvent(.didComplete)
        case .ended, .cancelled:
            self.coordinator.onInteractiveTransitionEvent(.didCancel)
        default: ()
        }
    }
}

extension EZNavigationControllerTransitionHelper: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.edgeGesture == gestureRecognizer {
            return true
        }
        return false
    }
    
}
