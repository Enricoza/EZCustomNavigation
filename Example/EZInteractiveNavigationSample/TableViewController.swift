//
//  tableviewcontroller.swift
//  EZInteractiveNavigationSample
//
//  Created by Serg Buglakov on 12.01.2021.
//  Copyright © 2021 Enrico Zannini. All rights reserved.
//

import UIKit

class TableDemo: UITableViewController {
    var n: Int = 10
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return n
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            n -= 1
        }
    }
    
    // TODO: Find a way to make this work
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: UIContextualAction.Style.normal,
                               title: "Action",
                               handler: { (action, view, completion) in
                                completion(true)
            })
        ])
    }
    
}
