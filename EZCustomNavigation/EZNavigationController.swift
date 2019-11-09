//
//  EZNavigationController.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit

/**
 * A specialization of the standard UINavigationController that enables pan-to-pop.
 *
 * Pan-to-pop allows the user to pop view controllers inside the navigation controller
 * by panning from the center of the screen too.
 * Pan from the left edge is also present, and will take precedence to any other gesture recognizer.
 * Pan-to-pop is also enabled, by default, on top of every horizontally-scrollable scrollview, when it's left offset is 0.
 *
 * You can customize this behavior with the static property `UIScrollView.shouldAvoidLeftBounceBlock` for every scrollView
 * Or with the istance property `shouldAvoidLeftBounceBlock` of the single istance of UIScrollView.
 *
 * If you wish to customize some behavior, some animation or some interaction, you must not use this class.
 * Use the methods of the UINavigationController extension instead:
 * - `addCustomTransitioning(_:onShouldPopViewController:)`
 * - `removeCustomTransitioning()`
 *
 * Passing your own implementation of `EZNavigationControllerTransitionHelper`, with your own animator and interactors.
 */
open class EZNavigationController: UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addCustomTransitioning()
    }
    
    deinit {
        removeCustomTransitioning()
    }
}

