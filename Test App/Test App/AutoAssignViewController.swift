//
//  AutoAssignViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/6/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class AutoAssignViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allUsers : [PFUser] = []
    var allChores : [PFObject] = []
    var currentUser : PFUser = PFUser.currentUser()
    var selectedUsers : [PFUser] = []
    var selectedChores : [PFObject] = []
    
    @IBOutlet var choresTable: UITableView!
    @IBOutlet var peopleTable: UITableView!
    
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
                        //self.allChores.sort({ $0.fileID > $1.fileID })
                        //TODO sort alphabetically
                        self.choresTable.reloadData()
                        self.peopleTable.reloadData()
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        if (tableView.tag == 21) {
            return self.allChores.count
        } else if (tableView.tag == 22) {
            return self.allUsers.count
        } else {
            println("tags not recognzied")
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView.tag == 21) {
            println("this is not exactly the same as in the view to view all")
            let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
            
            //TODO I don't know if this userForSection declaration is okay
            
            var specificChore : PFObject = self.allChores[indexPath.row]
            var choreTitle : String = specificChore.objectForKey("description") as String
            var specificChoreID : Int = specificChore.objectForKey("ID") as Int
        
            //TODO fix finding specificChore
            println("specific chore is ")
            println(specificChore)
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
            //TODO if otherPeopleFullNames is empty that label shouldn't be displayed and cell resized
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
            if contains(self.selectedChores, specificChore) {
                println("chore is selected")
                buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
            } else {
                println("chore is not selected")
                buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
            }
            
            return cell
        } else if (tableView.tag == 22) {
            println("this should be exactly the same as in manual once it works, minus clickable checkboxes")
        } else {
            println("shouldn't get here")
        }
    }
    
    @IBAction func selectAllChoresClicked(sender: AnyObject) {
        //if not all selected, select all
        if (self.selectedChores.count != self.allChores.count) {
            self.selectedChores = []
            for chore in self.allChores {
                self.selectedChores.append(chore)
                //chore.saveEventually()
            }
        //if all selected, deselect all
        } else {
            self.selectedChores = []
        }
        choresTable.reloadData()
    }

    @IBAction func selectAllPeopleClicked(sender: AnyObject) {
        if (self.selectedUsers.count != self.allUsers.count) {
            self.selectedUsers = []
            for person in self.allUsers {
                self.selectedUsers.append(person)
                //person.saveEventually()
            }
        } else {
            self.selectedUsers = []
        }
        peopleTable.reloadData()
    }
    
    func tableView(tableView : UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Row " + String(indexPath.row) + " selected")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
