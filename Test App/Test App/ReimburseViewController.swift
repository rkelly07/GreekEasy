//
//  ReimburseViewController.swift
//  Test App
//
//  Created by Ryan Kelly on 4/4/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ReimburseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reimburseTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var reimbursements:[PFObject] = []
    var currentReimbursement:PFObject!
    var user:PFUser?
    
    var reimbursementDates:[String] = []
    var reimbursementNames:[String] = []
    var reimbursementAmounts:[String] = []
    
    let dateFormatter = NSDateFormatter()
    let dateFormatString = "MM/dd"
    
    
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
        
        //Load Reimbursements (Date, Name, Amount)
        var query = PFQuery(className: "Reimburse")
        self.user = PFUser.currentUser()
        query.whereKey("houseID", equalTo: self.user!["houseID"])
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // Extract reimbursements in unspecified order
                var unsortedReimbursements: [PFObject] = []
                for object in objects{
                    unsortedReimbursements.append(object as PFObject)
                }
                // Sort reimbursements by increasing date
                self.reimbursements = unsortedReimbursements.sorted( { ($0.updatedAt as NSDate).compare($1.updatedAt as NSDate) == NSComparisonResult.OrderedAscending } )
                
                // Fill relevant fields
                for reimbursement in self.reimbursements {
                    var currentDate = reimbursement.updatedAt as NSDate
                    var formattedDate = self.dateFormatter.stringFromDate(currentDate)
                    self.reimbursementDates.append(formattedDate)
                    
                    var currentName = reimbursement["name"] as String
                    self.reimbursementNames.append(currentName)
                    
                    var currentAmount = reimbursement["amount"] as Double
                    var formattedAmount = String(format:"$%.2f", currentAmount)
                    self.reimbursementAmounts.append(formattedAmount)
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.reimburseTable.reloadData()
            } else {
                NSLog(error.description)
            }
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            var destination = segue.destinationViewController as ReimburseSingleViewController
            
            // Send event and formatter to detail view
            destination.incoming = self.currentReimbursement
            destination.formatter = self.dateFormatter
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.reimbursements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        // Set Labels
        (cell.contentView.viewWithTag(1) as UILabel).text = (self.reimbursementDates.isEmpty) ? "" : self.reimbursementDates[indexPath.row]
        (cell.contentView.viewWithTag(2) as UILabel).text = (self.reimbursementNames.isEmpty) ? "" : self.reimbursementNames[indexPath.row]
        (cell.contentView.viewWithTag(3) as UILabel).text = (self.reimbursementAmounts.isEmpty) ? "" : self.reimbursementAmounts[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentReimbursement = self.reimbursements[indexPath.row]
        performSegueWithIdentifier("showDetail", sender:nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let creator = self.reimbursements[indexPath.row]["createdBy"] as String
        return (self.user!["treasurer"] as Bool == true) || (creator == self.user!["username"] as String)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Delete cell from Parse DB and table view; reload data
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let itemToDelete = self.reimbursements[indexPath.row]
            
            itemToDelete.deleteEventually()
            
            self.reimbursements.removeAtIndex(indexPath.row)
            self.reimbursementDates.removeAtIndex(indexPath.row)
            self.reimbursementNames.removeAtIndex(indexPath.row)
            self.reimbursementAmounts.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            self.reimburseTable.reloadData()
        }
    
    }
    
}