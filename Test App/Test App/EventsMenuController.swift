//
//  EventsMenuController.swift
//  Test App
//
//  Created by Andrew Titus on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class EventsMenuController: MenuViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: // Events - current view, so simply toggle menu
            break
        case 1: // To-Dos
            var storyboard2 = UIStoryboard(name: "ToDoStoryboard", bundle: nil)
            var vc2 = storyboard2.instantiateViewControllerWithIdentifier("todo") as UIViewController
            println(vc2)
            presentViewController(vc2, animated: false, completion: nil)
            break
        case 2: // Reimburse
            println("implement yo shit")
            break
        default: // Error
            NSLog("error; invalid row tapped")
            break
        }
    }
}
