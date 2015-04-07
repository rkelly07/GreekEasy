//
//  EventsTableViewController.swift
//  Events
//
//  Created by Andrew Titus on 3/27/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit
/*
import ParseUI

class GreekEasyLogInViewController: PFLogInViewController {
    let blueR = CGFloat(13.0 / 255.0)
    let blueG = CGFloat(86.0 / 255.0)
    let blueB = CGFloat(95.0 / 255.0)
    
    let orangeR = CGFloat(204.0 / 255.0)
    let orangeG = CGFloat(102.0 / 255.0)
    let orangeB = CGFloat(1.0 / 255.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueColor = UIColor(red: blueR, green: blueG, blue: blueB, alpha: 1.0)
        let orangeColor = UIColor(red: orangeR, green: orangeG, blue: orangeB, alpha: 1.0)
        
        // Set background color and logo
        let logoView = UIImageView(image: UIImage(named: "full_logo.png"))
        self.logInView.logo = logoView
        
        // Set button colors
        self.logInView.logInButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.logInButton.backgroundColor = orangeColor
        
        self.logInView.passwordForgottenButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.passwordForgottenButton.setTitleColor(orangeColor, forState: UIControlState.Normal)
        
        self.logInView.signUpButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView.signUpButton.backgroundColor = blueColor
        
        // Set fields
        self.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten)
    }
}

class GreekEasySignUpViewController: PFSignUpViewController {
    let blueR = CGFloat(13.0 / 255.0)
    let blueG = CGFloat(86.0 / 255.0)
    let blueB = CGFloat(95.0 / 255.0)
    
    let orangeR = CGFloat(204.0 / 255.0)
    let orangeG = CGFloat(102.0 / 255.0)
    let orangeB = CGFloat(1.0 / 255.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueColor = UIColor(red: blueR, green: blueG, blue: blueB, alpha: 1.0)
        let orangeColor = UIColor(red: orangeR, green: orangeG, blue: orangeB, alpha: 1.0)
        
        // Set background color and logo
        let logoView = UIImageView(image: UIImage(named: "full_logo.png"))
        self.signUpView.logo = logoView
        
        // Set colors
        self.signUpView.signUpButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.signUpView.signUpButton.backgroundColor = blueColor
    }
}
*/

//class EventsViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
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
        
        // Load events
        var query = PFQuery(className: "Event")
        self.user = PFUser.currentUser()
        
        if self.user != nil {
            query.whereKey("houseID", equalTo: self.user!["houseID"])
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // Extract events in unspecified order
                    var unsortedEvents: [PFObject] = []
                    for object in objects {
                        unsortedEvents.append(object as PFObject)
                    }
                    
                    // Sort events by increasing date
                    self.events = unsortedEvents.sorted( { ($0["date"] as NSDate).compare($1["date"] as NSDate) == NSComparisonResult.OrderedAscending } )
                    
                    // Fill relevant fields
                    for event in self.events {
                        var currentEvent = event["name"] as String
                        self.eventNames.append(currentEvent)
                        
                        var currentDate = event["date"] as NSDate
                        var formattedDate = self.dateFormatter.stringFromDate(currentDate)
                        self.eventDates.append(formattedDate)
                        
                        var currentLocation = event["location"] as String
                        self.eventLocations.append(currentLocation)
                    }
                    
                    // Stop activity indicator and reload table view
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.eventsTable.reloadData()
                } else {
                    // Error occurred; check description
                    NSLog(error.description)
                }
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            // TODO: Present signup screen
            PFUser.logInWithUsername("tylerf", password: "greek")
        } else {
            // Start activity indicator
            self.activityIndicator.startAnimating()
            self.activityIndicator.hidden = false
            
            // Load events
            var query = PFQuery(className: "Event")
            self.user = PFUser.currentUser()
            
            if self.user != nil {
                query.whereKey("houseID", equalTo: self.user!["houseID"])
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        // Extract events in unspecified order
                        var unsortedEvents: [PFObject] = []
                        for object in objects {
                            unsortedEvents.append(object as PFObject)
                        }
                        
                        // Sort events by increasing date
                        self.events = unsortedEvents.sorted( { ($0["date"] as NSDate).compare($1["date"] as NSDate) == NSComparisonResult.OrderedAscending } )
                        
                        // Fill relevant fields
                        for event in self.events {
                            var currentEvent = event["name"] as String
                            self.eventNames.append(currentEvent)
                            
                            var currentDate = event["date"] as NSDate
                            var formattedDate = self.dateFormatter.stringFromDate(currentDate)
                            self.eventDates.append(formattedDate)
                            
                            var currentLocation = event["location"] as String
                            self.eventLocations.append(currentLocation)
                        }
                        
                        // Stop activity indicator and reload table view
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                        self.eventsTable.reloadData()
                    } else {
                        // Error occurred; check description
                        NSLog(error.description)
                    }
                }
            }
        }
    }
    
    /*
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {

        // Continue login process if nothing added
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        // User logged in; dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        self.eventsTable.reloadData()
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("Failed to log in...")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        // Password entered correctly or not
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        // User logged in; dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // Fix BS with "additional" key and "houseID" key
        var currentUser = PFUser.currentUser()
        currentUser.setObject(user.objectForKey("additional"), forKey: "houseID")
        currentUser.removeObjectForKey("additional")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        println("Failed to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        println("User dismissed sign up...")
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as EventDetailController
            
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
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        // Set labels
        (cell.contentView.viewWithTag(1) as UILabel).text = (self.eventDates.isEmpty) ? "" : self.eventDates[indexPath.row]
        (cell.contentView.viewWithTag(2) as UILabel).text = (self.eventNames.isEmpty) ? "" : self.eventNames[indexPath.row]
        (cell.contentView.viewWithTag(3) as UILabel).text = (self.eventLocations.isEmpty) ? "" : self.eventLocations[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentEvent = self.events[indexPath.row]
        performSegueWithIdentifier("showDetail", sender:nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Allow events to be edited by those who created them
        let creator = self.events[indexPath.row]["createdBy"] as String
        return (creator == self.user!["username"] as String)
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