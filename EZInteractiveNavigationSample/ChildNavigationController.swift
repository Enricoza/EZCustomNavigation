//
//  ChildNavigationController.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 27/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit
import EZCustomNavigation


class ChildNavigationController: EZNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
    }
}
