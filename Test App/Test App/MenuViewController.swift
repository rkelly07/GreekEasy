//
//  MenuTableViewController.swift
//  Test App
//
//  Created by Andrew Titus on 3/11/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct MenuItem {
        let name:String!
    }
    
    let blueR = CGFloat(13.0 / 255.0)
    let blueG = CGFloat(86.0 / 255.0)
    let blueB = CGFloat(95.0 / 255.0)
    
    let menuItems = [MenuItem(name: "Events"), MenuItem(name: "To-Dos"), MenuItem(name: "Reimburse")]
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.textColor = UIColor(red: self.blueR, green: self.blueG, blue: self.blueB, alpha: 1.0)
        cell.textLabel?.text = menuItems[indexPath.row].name
        
        // Configure the cell...

        return cell
    }
    
    @IBAction func logOut() {
        PFUser.logOut()
        
        var loginStoryboard = UIStoryboard(name: "LogIn", bundle: nil)
        var logInVC = loginStoryboard.instantiateViewControllerWithIdentifier("logIn") as UIViewController
        presentViewController(logInVC, animated: true, completion: nil)
    }
}
