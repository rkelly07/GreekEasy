//
//  ToDoViewController2.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/2/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO add IBoutlet to tableView
    
    var allUsers : [PFUser] = []
    var allChores : [PFObject] = []
    var allEvents : [PFObject] = []
    var allReimbursements : [PFObject] = []
    var currentUser : PFUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get all users and add to allUsers array
        var usersQuery = PFQuery(className: "_User")
        usersQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        usersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allUsers.append(object as PFUser)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var choresQuery = PFQuery(className: "Chores")
        choresQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        choresQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allChores.append(object as PFObject)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var eventsQuery = PFQuery(className: "_User")
        eventsQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        eventsQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allEvents.append(object as PFObject)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var reimbursementsQuery = PFQuery(className: "_User")
        reimbursementsQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        reimbursementsQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allEvents.append(object as PFObject)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
    }
    
    var sectionTitles : [String]! = []
    
    func populateSectionTitlesArray() {
        for person in allUsers {
            //println("Entering")
            var firstName : String = person.objectForKey("firstName") as String
            var lastName : String = person.objectForKey("lastName") as String
            var fullName : String = firstName + lastName
            sectionTitles.append(fullName)
        }
        sectionTitles = sorted(sectionTitles, {$0 < $1})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    //how many rows in each section = number of chores for a given person
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        var personName : String! = sectionTitles[section]
    //        var choreIDs : [Int]! = NameToChoreIDsDictionary[personName]
    //        return choreIDs.count
    //    }
    
    //how many sections in the chores table = number of people
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        populateSectionTitlesArray()
        //return sectionTitles.count
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var userChores : [Int] = []
        var personName : String = sectionTitles[section]
        var sectionChoresQuery = PFQuery(className: "_User")
        sectionChoresQuery.whereKey("objectID", equalTo:PFUser.currentUser().objectForKey("objectID"))
        sectionChoresQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for user in objects {
                    userChores = ((user).objectForKey("currentChores") as [Int])
                    println(userChores)
                }
            } else {
                NSLog(error.description)
            }
        }
        return 5
        //return userChores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        var personName : String = sectionTitles[indexPath.section]
        var choreNumberForIndividual : Int = indexPath.row
        (cell.contentView.viewWithTag(11) as UILabel).text = "test"
        (cell.contentView.viewWithTag(11) as UILabel).font = UIFont.boldSystemFontOfSize(16.0)
        (cell.contentView.viewWithTag(12) as UILabel).text = "test"
        (cell.contentView.viewWithTag(13) as UILabel).text = "other peeps"
        
        return cell
    }
    
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
    //        var personName : String! = sectionTitles[indexPath.section]
    //        var choreNumberForIndividual : Int! = indexPath.row
    //        var choreID : Int! = NameToChoreIDsDictionary[personName]![choreNumberForIndividual]
    //        var chorePoints : Int! = choreIDtoPointsDictionary[choreID]
    //        var choreDescription : String! = choreIDtoDescriptionDictionary[choreID]
    //        println(choreIDtoDoneOrNotDictionary)
    //        var choreDone : Bool! = choreIDtoDoneOrNotDictionary[choreID]
    //        //        cell.textLabel!.text! = choreDescription
    //        //        cell.detailTextLabel!.text! = String("Points : " + String(chorePoints))
    //
    //        (cell.contentView.viewWithTag(11) as UILabel).text = choreDescription
    //        (cell.contentView.viewWithTag(11) as UILabel).font = UIFont.boldSystemFontOfSize(16.0)
    //        (cell.contentView.viewWithTag(12) as UILabel).text = String(chorePoints)
    //        (cell.contentView.viewWithTag(13) as UILabel).text = "other peeps"
    //
    //        var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
    //        var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
    //
    //        var buttonInCell : UIButton = (cell.contentView.viewWithTag(111) as UIButton)
    //
    //        if choreDone == true {
    //            buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
    //        } else {
    //            buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
    //        }
    //        return cell
    //    }
    
    //gives table sections titles = person's name and points
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
    
    //says you can edit a cell in the table. Only true if role = house manager
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
