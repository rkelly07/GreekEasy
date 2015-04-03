//
//  ManualAssignmentViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ManualAssignmentViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var allUsers : [PFUser] = []
    var allChores : [PFObject] = []
    var currentUser : PFUser = PFUser.currentUser()
    
    @IBOutlet var ResetAllToIncompleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(currentUser.objectForKey("houseID"))
        
        //get all users and add to allUsers array
        var usersQuery = PFQuery(className: "_User")
        usersQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        usersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("Inside find objects block")
                self.allUsers = objects as [PFUser]!
                println("going to print user array")
                println(self.allUsers)
                var choresQuery = PFQuery(className: "ToDo")
                choresQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
                choresQuery.orderByAscending("description")
                choresQuery.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        self.allChores = objects as [PFObject]!
                        self.tableView.reloadData()
                    } else {
                        NSLog(error.description)
                    }
                }
            } else {
                println("In userquery error")
                NSLog(error.description)
            }
        }
        println("before reload data after usersquery")
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //no sections here - maybe later
    }
    
    func findUserByFullName(userFullName : String) -> PFUser {
        var userForSection : PFUser = PFUser()
        for user in self.allUsers {
            if ((user.objectForKey("firstName") as String) + " " + (user.objectForKey("lastName") as String)) == userFullName {
                userForSection = user
            }
        }
        return userForSection
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allChores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        var specificChore : PFObject = self.allChores[indexPath.row]
        var specificChoreID : Int = specificChore.objectForKey("ID") as Int
        var choreTitle : String = specificChore.objectForKey("description") as String
        var chorePoints : Int = specificChore.objectForKey("points") as Int
        var choreStatus : Bool = specificChore.objectForKey("doneOrNot") as Bool
        var peopleOnChore : [PFUser] = []
        
        //go through other users and see who has the same choreID
        for person in self.allUsers {
            if (person.objectForKey("currentChores") as NSArray).containsObject(specificChoreID) {
                //need to exclude person whose section it is
                var firstName : String = person.objectForKey("firstName") as String
                var lastName : String = person.objectForKey("lastName") as String
                var fullName : String = firstName + " " + lastName
                peopleOnChore.append(person)
            }
        }
        
        var peopleFullNames : [String] = []
        for person in peopleOnChore {
            var personFirstName : String = person.objectForKey("firstName") as String
            var personLastName : String = person.objectForKey("lastName") as String
            peopleFullNames.append(personFirstName + " " + personLastName)
        }
        var peopleNamesString : String = ""
        for name in peopleFullNames {
            if peopleNamesString == "" {
                peopleNamesString = peopleNamesString + name
            } else {
                peopleNamesString = peopleNamesString + ", " + name
            }
        }
        //TODO if no one is one chore don't display
        //temporary solution for too long titles
        var numChars : Int = 25
        if countElements(choreTitle) > numChars {
            choreTitle = (choreTitle as NSString).substringToIndex(numChars) + String("...")
        }
        (cell.contentView.viewWithTag(11) as UILabel).text = choreTitle
        (cell.contentView.viewWithTag(11) as UILabel).font = UIFont.boldSystemFontOfSize(18.0)
        (cell.contentView.viewWithTag(12) as UILabel).text = "Points: " + String(chorePoints)
        (cell.contentView.viewWithTag(13) as UILabel).text = peopleNamesString
        
        var buttonInCell : UIButton = (cell.contentView.viewWithTag(111) as UIButton)
        var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
        var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
        if choreStatus == true {
            println("chore is done")
            buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
        } else {
            println("chore is not done")
            buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
        }
        
        return cell
    }
    

    @IBAction func changeChoreStatus(sender: AnyObject) {
        println("Button press works")
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(position)!
        var specificChore : PFObject = self.allChores[indexPath.row]
        var specificChoreID : Int = specificChore.objectForKey("ID") as Int
        var choreStatus : Bool = specificChore.objectForKey("doneOrNot") as Bool
        
        println(indexPath.section)
        println(indexPath.row)
        
        //change chorestatus - need to make sure this saves on parse
        if choreStatus == false {
            //choreStatus = true
            specificChore["doneOrNot"] = true
            tableView.reloadData()
            //TODO update user points - add here
        } else {
            //choreStatus = false
            specificChore["doneOrNot"] = false
            tableView.reloadData()
            //TODO update user points - subtract here
        }
        println(specificChore)
        specificChore.saveEventually()
    }
    
    @IBAction func resetAllToIncomplete(sender: AnyObject) {
        for chore in self.allChores {
            chore["doneOrNot"] = false
            chore.saveEventually()
        }
        tableView.reloadData()
    }
    
    func tableView(tableView : UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Row " + String(indexPath.row) + " selected")
//        var alertView = UIAlertController(title: "Sample Popup", message: "You clicked cell at index : \(indexPath!.row)", preferredStyle: UIAlertControllerStyle.Alert)
//        var textField:UITextField = UITextField(frame: CGRectMake(0, 0, 10, 10))
//        textField.text = "textfield test"
//        //let textField = alert.textFieldAtIndex(0)
//        alertView.addTextFieldWithConfigurationHandler(textField as UITextField)
//        textField.placeholder = "Foo!"
//        textField.key
//        alertView.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    //need to have checkboxes be editable
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    //removes data from array and updates table view when deleting
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // remove data from array and udpate tableview
        }
    }
    
}
