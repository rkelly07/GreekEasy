//
//  ReimburseViewController.swift
//  Test App
//
//  Created by Ryan Kelly on 4/4/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import Foundation

class ReimburseViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var reimburseTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var reimbursements:[PFObject] = []
    var currentReimbursement:PFObject!
    var user:PFUser?
    
    var reimbursementDescriptions:[String] = []
    var reimbursementAmounts:[String] = []
    var reimbursementNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start activity indicator
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        // Set up menu
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //Load Reimbursements (Description, Name, Amount)
        var query = PFQuery(className: "Reimburse")
        self.user = PFUser.currentUser()
        query.whereKey("houseID", equalTo: self.user!["houseID"])
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var unsortedReimbursements: [PFObject] = []
                for object in objects{
                    unsortedReimbursements.append(object as PFObject)
                }
                self.reimbursements = unsortedReimbursements.sorted( { ($0["date"] as NSDate).compare($1["date"] as NSDate) == NSComparisonResult.OrderedAscending } )
                
                for reimbursement in self.reimbursements {
                    var currentReimbursement = reimbursement["description"] as String
                    self.reimbursementDescriptions.append(currentReimbursement)
                    
                    var currentName = reimbursement["name"] as String
                    self.reimbursementNames.append(currentName)
                    
                    var currentAmount = reimbursement["amount"] as Double
                    var formattedAmount = String(format:"%.2f", currentAmount)
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
    
    //override func prepareForSEgue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //if segue.identifier == "reimburse"
    //}
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.reimbursements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        (cell.contentView.viewWithTag(1) as UILabel).text = (self.reimbursementAmounts.isEmpty) ? "" : self.reimbursementAmounts[indexPath.row]
        (cell.contentView.viewWithTag(2) as UILabel).text = (self.reimbursementDescriptions.isEmpty) ? "" : self.reimbursementDescriptions[indexPath.row]
        (cell.contentView.viewWithTag(3) as UILabel).text = (self.reimbursementNames.isEmpty) ? "" : self.reimbursementNames[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentReimbursement = self.reimbursements[indexPath.row]
        performSegueWithIdentifier("showDetail", sender:nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let creator = self.reimbursements[indexPath.row]["createdBy"] as String
        return (creator == self.user!["username"] as String)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let itemToDelete = self.reimbursements[indexPath.row]
            
            itemToDelete.deleteEventually()
            
            self.reimbursements.removeAtIndex(indexPath.row)
            self.reimbursementAmounts.removeAtIndex(indexPath.row)
            self.reimbursementDescriptions.removeAtIndex(indexPath.row)
            self.reimbursementNames.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            self.reimburseTable.reloadData()
        }
    
    }
    
}