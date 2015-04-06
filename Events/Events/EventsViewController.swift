//
//  EventsTableViewController.swift
//  Events
//
//  Created by Andrew Titus on 3/27/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var eventNames:[String] = []
    var events:[PFObject] = []
    var currentEvent:PFObject!
    
    // TODO: Granularity of time in detail view
    // TODO: Formatting of menu cells in events
    // TODO: Enum and PickerView for category of events
    // TODO: Sort events/sections by category
    // TODO: User can delete their own events
    // TODO: Signups and accounts
    // TODO: Cacheing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        // Set up menu
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Load events
        var query = PFQuery(className: "Event")
        var user = PFUser.currentUser()
        query.whereKey("houseID", equalTo: user["houseID"])
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                for object in objects {
                    self.events.append(object as PFObject)
                    
                    var currentEvent = object["name"] as String
                    self.eventNames.append(currentEvent)
                    
                    self.eventsTable.reloadData()
                }
            } else {
                NSLog(error.description)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as EventDetailController
            
            destination.incoming = self.currentEvent
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentEvent = self.events[indexPath.row]
        performSegueWithIdentifier("showDetail", sender:nil)
    }
}

