//
//  MenuTableViewController.swift
//  Test App
//
//  Created by Andrew Titus on 3/11/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    struct MenuItem {
        let name:String!
    }
    
    let menuItems = [MenuItem(name: "Events"), MenuItem(name: "To-Dos"), MenuItem(name: "Reimburse")]
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = menuItems[indexPath.row].name
        
        // Configure the cell...

        return cell
    }
}
