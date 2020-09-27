//
//  EZTransitionHelper.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 02/11/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit

/**
 * An helper class that attaches gestures to the navigation controller view instance and handles the gestures actions and delegates to then inform a coordinator instance about interaction events.
 */
public final class EZNavigationControllerTransitionHelper: NSObject {
    
    let coordinator: EZTransitionCoordinator
    private var popGesture: UIScreenEdgePanGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var unpopGesture: UIScreenEdgePanGestureRecognizer?
    private(set) var onShouldPopViewController: (()->(Bool))?
    private(set) var onShouldUnpopViewController: (()->(Bool))?
    private weak var dismissGestureView: UIView? {
        didSet {
            detachDismissGestures(from: oldValue)
        }
    }
    private weak var unpopGestureView: UIView? {
        didSet {
            detachUnpopGesture(from: oldValue)
        }
    }
    
    /**
     * The delegate provided for the navigation controller
     */
    public var navigationControllerDelegate: UINavigationControllerDelegate {
        return coordinator
    }
    
    /**
     * Creates a TransitionHelper with a coordinator
     */
    public init(transitionCoordinator: EZTransitionCoordinator = EZTransitionCoordinator()) {
        self.coordinator = transitionCoordinator
    }
    
    /**
     * Attaches the gesture to the navigation controller and asks to the callback if a pop action can be initialized.
     *
     * - parameter navigationController: The navigationController to which every gesture can be attached
     * - parameter onShouldPopViewController: The callback that informs that a pop should happen. If the navigationController actually pops the view controller it must return true to inform the helper of the ongoing pop action.
     */
    public func attachDismissGestures(to navigationController: UINavigationController, onShouldPopViewController: @escaping (()->(Bool))) {
        guard let view = navigationController.view else {
            return
        }
        self.dismissGestureView = view
        self.onShouldPopViewController = onShouldPopViewController
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePopSwipe(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        edgeSwipeGestureRecognizer.delegate = self
        self.popGesture = edgeSwipeGestureRecognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePopSwipe(_:)))
        self.panGesture = panGesture
        view.addGestureRecognizer(panGesture)
    }
    
    public func attachUnpopGesture(to navigationController: UINavigationController, onShouldUnpopViewController: @escaping (()->(Bool))) {
        guard let view = navigationController.view else {
            return
        }
        self.unpopGestureView = view
        self.onShouldUnpopViewController = onShouldUnpopViewController
        let rightEdgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleUnpopSwipe(_:)))
        rightEdgeSwipeGestureRecognizer.edges = .right
        view.addGestureRecognizer(rightEdgeSwipeGestureRecognizer)
        rightEdgeSwipeGestureRecognizer.delegate = self
        self.unpopGesture = rightEdgeSwipeGestureRecognizer
    }
    
    /**
     * Detaches all the gestures from the navigation controllers view
     */
    public func detachDismissGestures() {
        dismissGestureView = nil
    }
    
    public func detachUnpopGesture() {
        unpopGestureView = nil
    }
    
    private func detachDismissGestures(from view: UIView?) {
        if let edgeGesture = self.popGesture {
            view?.removeGestureRecognizer(edgeGesture)
            self.popGesture = nil
        }
        if let panGesture = self.panGesture {
            view?.removeGestureRecognizer(panGesture)
            self.panGesture = nil
        }
        self.onShouldPopViewController = nil
    }
    
    private func detachUnpopGesture(from view: UIView?) {
        if let unpopGesture = self.unpopGesture {
            view?.removeGestureRecognizer(unpopGesture)
            self.unpopGesture = nil
        }
        self.onShouldUnpopViewController = nil
    }
}

extension EZNavigationControllerTransitionHelper: UIGestureRecognizerDelegate {
    
    /**
     * Force the edge gesture to be prioritized 
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.popGesture == gestureRecognizer || self.unpopGesture == gestureRecognizer {
            return true
        }
        return false
    }
    
}
