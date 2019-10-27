//
//  EZNavigationController.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit

class EZNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomTransitioning()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    private var transitionCoordinatorHelper: EZTransitionCoordinator?
    private var edgeGesture: UIPanGestureRecognizer?
    
    func addCustomTransitioning() {
        guard transitionCoordinatorHelper == nil else {
            return
        }
        
        let object = EZTransitionCoordinator()
        transitionCoordinatorHelper = object
        delegate = object
        let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer)
        edgeSwipeGestureRecognizer.delegate = self
        self.edgeGesture = edgeSwipeGestureRecognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        print("SWIPEEEE \(gestureRecognizer.translation(in: gestureRecognizer.view!))")
        guard let gestureRecognizerView = gestureRecognizer.view else {
            return
        }
        
        let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
        
        switch gestureRecognizer.state {
        case .began:
            transitionCoordinatorHelper?.onInteractiveTransitionEvent(.started)
            popViewController(animated: true)
        case .changed:
            transitionCoordinatorHelper?.onInteractiveTransitionEvent(.updated(progress: percent))
        case .ended where percent > 0.3:
            transitionCoordinatorHelper?.onInteractiveTransitionEvent(.completed)
        case .ended, .cancelled:
            transitionCoordinatorHelper?.onInteractiveTransitionEvent(.cancelled)
        default: ()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.edgeGesture == gestureRecognizer {
            return true
        }
        return false
    }
}
