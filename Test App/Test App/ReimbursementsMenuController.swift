//
//  ReimbursementsMenuController.swift
//  Test App
//
//  Created by Ryan Kelly on 4/6/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ReimbursementsMenuController: MenuViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: // Events
            var storyboard2 = UIStoryboard(name: "Events", bundle: nil)
            var vc2 = storyboard2.instantiateViewControllerWithIdentifier("events") as UIViewController
            presentViewController(vc2, animated: false, completion: nil)
            break
        case 1: // To-Dos
            var storyboard3 = UIStoryboard(name: "ToDoStoryboard", bundle: nil)
            var vc3 = storyboard3.instantiateViewControllerWithIdentifier("todo") as UIViewController
            presentViewController(vc3, animated: false, completion: nil)
            break
        case 2: // Reimburse - current view
            self.performSegueWithIdentifier("reimbursePress", sender: nil)
            break
            
        default: // Error
            NSLog("error; invalid row tapped")
            break
        }
    }
}
