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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateScroll(vertical: false)
        // Do any additional setup after loading the view.
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
            lblScroll.text = """
            Horizontal Scrollable Content
            (You can pan from edge)
            """
        }
        
        activateScroll(vertical: stackView.axis == .vertical)
    }
    
    func activateScroll(vertical: Bool) {
        if vertical {
            self.stackViewHeight.isActive = !vertical
            self.stackViewWidth.isActive = vertical
        } else {
            self.stackViewWidth.isActive = vertical
            self.stackViewHeight.isActive = !vertical
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
