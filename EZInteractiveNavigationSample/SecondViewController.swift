//
//  SecondViewController.swift
//  EZInteractiveNavigationSample
//
//  Created by Enrico Zannini on 26/10/2019.
//  Copyright © 2019 Enrico Zannini. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var stackViewHeight: NSLayoutConstraint!
    @IBOutlet var stackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var lblScroll: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateScrollConstraints(vertical: false)
        // Do any additional setup after loading the view.
        scrollView.shouldAvoidLeftBounce = true
        updateHorizontalText()
    }
    
    @IBAction func toggleStackAction(_ sender: Any) {
        if stackView.axis == .horizontal {
            stackView.axis = .vertical
            lblScroll.text = """
            Vertical Scrollable Content
            (You can pan from center too)
            """
        } else {
            stackView.axis = .horizontal
            updateHorizontalText()
        }
        activateScrollConstraints(vertical: stackView.axis == .vertical)
    }
    
    func updateHorizontalText() {
        lblScroll.text = """
        Horizontal Scrollable Content
        (You can pan from edge)
        (Or from center if you are at far left)
        """
    }
    
    func activateScrollConstraints(vertical: Bool) {
        if vertical {
            self.stackViewHeight.isActive = !vertical
            self.stackViewWidth.isActive = vertical
        } else {
            self.stackViewWidth.isActive = vertical
            self.stackViewHeight.isActive = !vertical
        }
    }
    
}
