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
    
    var events:[PFObject] = []
    var currentEvent:PFObject!
    var user:PFUser?
    
    var eventNames:[String] = []
    var eventDates:[String] = []
    var eventLocations:[String] = []
    
    let dateFormatter = NSDateFormatter()
    let dateFormatString = "MM/dd"
    
    // TODO: Log-in menu
    // TODO: Check for network connection
    // TODO: Caching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start activity indicator
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        // Set up date formatter
        self.dateFormatter.dateFormat = dateFormatString
        
        // Set up menu
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load events
        var query = PFQuery(className: "Event")
        self.user = PFUser.currentUser()
        
        // Check if user signed in. If not, present login; else load data
        if self.user == nil {
            var loginStoryboard = UIStoryboard(name: "LogIn", bundle: nil)
            var logInVC = loginStoryboard.instantiateViewControllerWithIdentifier("logIn") as! UIViewController
            presentViewController(logInVC, animated: true, completion: nil)
        } else {
            query.whereKey("houseID", equalTo: self.user!["houseID"]!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // Extract events in unspecified order
                    var unsortedEvents: [PFObject] = []
                    for object in objects! {
                        unsortedEvents.append(object as! PFObject)
                    }
                    
                    // Sort events by increasing date
                    self.events = unsortedEvents.sorted( { ($0["date"] as! NSDate).compare($1["date"]as! NSDate) == NSComparisonResult.OrderedAscending } )
                    
                    // Fill relevant fields
                    for event in self.events {
                        var currentEvent = event["name"] as! String
                        self.eventNames.append(currentEvent)
                        
                        var currentDate = event["date"] as! NSDate
                        var formattedDate = self.dateFormatter.stringFromDate(currentDate)
                        self.eventDates.append(formattedDate)
                        
                        var currentLocation = event["location"] as! String
                        self.eventLocations.append(currentLocation)
                    }
                    
                    // Stop activity indicator and reload table view
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.eventsTable.reloadData()
                } else {
                    // Error occurred; check description
                    NSLog(error!.description)
                }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as! EventDetailController
            
            // Send event and formatter to detail view
            destination.incoming = self.currentEvent
            destination.formatter = self.dateFormatter
        }
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Set labels
        (cell.contentView.viewWithTag(1) as! UILabel).text = (self.eventDates.isEmpty) ? "" : self.eventDates[indexPath.row]
        (cell.contentView.viewWithTag(2) as! UILabel).text = (self.eventNames.isEmpty) ? "" : self.eventNames[indexPath.row]
        (cell.contentView.viewWithTag(3) as! UILabel).text = (self.eventLocations.isEmpty) ? "" : self.eventLocations[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentEvent = self.events[indexPath.row]
        performSegueWithIdentifier("showDetail", sender:nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Allow events to be edited by those who created them
        let creator = self.events[indexPath.row]["createdBy"] as! String
        return (creator == self.user!["username"] as! String)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Delete cell from Parse DB and table view; reload data
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let itemToDelete = self.events[indexPath.row]
            
            itemToDelete.deleteEventually()
            
            self.events.removeAtIndex(indexPath.row)
            self.eventNames.removeAtIndex(indexPath.row)
            self.eventLocations.removeAtIndex(indexPath.row)
            self.eventDates.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            self.eventsTable.reloadData()
        }
    }
}