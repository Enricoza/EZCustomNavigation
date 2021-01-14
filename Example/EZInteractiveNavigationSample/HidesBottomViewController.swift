//
//  HidesBottomViewController.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 09/01/2021.
//  Copyright © 2021 Enrico Zannini. All rights reserved.
//

import UIKit

class HidesBottomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        set (newValue) {
            
        }
    }

}
