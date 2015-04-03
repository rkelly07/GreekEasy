//
//  EventsTableViewController.swift
//  Events
//
//  Created by Andrew Titus on 3/27/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class EventsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var eventNames:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load events from Parse
        var query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    var currentEvent = object["name"] as String
                    self.eventNames.append(currentEvent)
                    self.eventsTable.reloadData()
                }
            } else {
                NSLog(error.description)
            }
        }
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = (self.eventNames.isEmpty) ? "" : self.eventNames[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}

