//
//  ToDoMenuController.swift
//  Test App
//
//  Created by Andrew Titus on 4/5/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoMenuController: MenuViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: // Events
            var storyboard2 = UIStoryboard(name: "Events", bundle: nil)
            var vc2 = storyboard2.instantiateViewControllerWithIdentifier("events") as UIViewController
            presentViewController(vc2, animated: false, completion: nil)
            break
        case 1: // To-Dos - current view
            self.performSegueWithIdentifier("todoPress", sender: nil)
            break
        case 2: // Reimburse
            var storyboard3 = UIStoryboard(name: "ReimbursementsStoryboard", bundle: nil)
            var vc3 = storyboard3.instantiateViewControllerWithIdentifier("reimburse") as UIViewController
            presentViewController(vc3, animated: false, completion: nil)
            break
        default: // Error
            NSLog("error; invalid row tapped")
            break
        }
    }
}