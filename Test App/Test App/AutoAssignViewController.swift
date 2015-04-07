//
//  AutoAssignViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/6/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class AutoAssignViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var choresTable: UITableView!
    @IBOutlet weak var peopleTable: UITableView!
    var allUsers : [PFUser] = []
    var allChores : [PFObject] = []
    var currentUser : PFUser = PFUser.currentUser()
    var selectedUsers : [PFUser] = []
    var selectedChores : [PFObject] = []
    

    
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
    
    func getUserChoresString(userOb: PFObject) -> String {
        var choreTitlesString : String = ""
        var userChores : [Int] = userOb.objectForKey("currentChores") as [Int]
        for choreID in userChores {
            for chore in self.allChores {
                if contains(userChores, chore.objectForKey("ID") as Int) {
                    if (choreTitlesString == "") {
                        choreTitlesString = chore.objectForKey("description") as String
                    } else {
                        choreTitlesString = choreTitlesString + ", " + (chore.objectForKey("description") as String)
                    }
                }
            }
        }
        return choreTitlesString
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        if (tableView.tag == 21) {
            println("this is not exactly the same as in the view to view all")
            
            
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
        } else if (tableView.tag == 22) {
            println("this should be exactly the same as in manual once it works, minus clickable checkboxes")
            var peopleFullNames : [String] = []
            for person in self.allUsers {
                var personFirstName : String = person.objectForKey("firstName") as String
                var personLastName : String = person.objectForKey("lastName") as String
                peopleFullNames.append(personFirstName + " " + personLastName)
            }
            var userFullName : String = peopleFullNames[indexPath.row]
            println("Looking at row for " + userFullName)
            var userPF : PFUser = findUserByFullName(userFullName)
            var userPoints : Int = userPF.objectForKey("totalPoints") as Int
            var userChores : [Int] = []
            var userChoresAsString = getUserChoresString(userPF)
            //println("String of chores for user is " + String(userChoresAsString))
            
            //TODO if otherPeopleFullNames is empty that label shouldn't be displayed and cell resized
            //temporary solution for too long titles
            var numChars : Int = 25
//            if countElements(userChoresAsString) > numChars {
//                userChoresAsString = (userChoresAsString).substringToIndex(numChars) + String("...")
//            }
//            if countElements(userChoresAsString) > numChars {
//                userChoresAsString = (userChoresAsString as NSString).substringToIndex(numChars) + String("...")
//            }
            
            (cell.contentView.viewWithTag(31) as UILabel).text = userFullName
            (cell.contentView.viewWithTag(31) as UILabel).font = UIFont.boldSystemFontOfSize(18.0)
            (cell.contentView.viewWithTag(32) as UILabel).text = "Points: " + String(userPoints)
            (cell.contentView.viewWithTag(33) as UILabel).text = userChoresAsString
            
            var buttonInCell : UIButton = (cell.contentView.viewWithTag(333) as UIButton)
            var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
            var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
            if contains(self.selectedUsers, userPF) {
                println("user is selected")
                buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
            } else {
                println("chore is not selected")
                buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
            }
        }
        return cell
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
    
    func autoAssignChores() -> Void {
    
        //get all chores sorted by points high to low
        var choresSortedHighToLow : [PFObject] = []
        var choresQuery = PFQuery(className: "ToDo")
        choresQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        choresQuery.orderByDescending("points")
        choresQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                choresSortedHighToLow = objects as [PFObject]!
            } else {
                NSLog(error.description)
            }
        }
        
        //we only want the selected chores
        for chore in choresSortedHighToLow {
            if !contains(self.selectedChores, chore) {
                var indexOfChore : Int = find(choresSortedHighToLow, chore)!
                choresSortedHighToLow.removeAtIndex(indexOfChore)
            }
        }
        
        
        //get all people sorted by points low to high
        var peopleSortedLowToHigh : [PFUser] = []
        var peopleQuery = PFQuery(className: "_User")
        peopleQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        peopleQuery.orderByAscending("totalPoints")
        peopleQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                peopleSortedLowToHigh = objects as [PFUser]!
            } else {
                NSLog(error.description)
            }
        }
        
        //we only want the selected people
        
        for person in peopleSortedLowToHigh {
            if !contains(self.selectedUsers, person) {
                var indexOfPerson : Int = find(peopleSortedLowToHigh, person)!
                peopleSortedLowToHigh.removeAtIndex(indexOfPerson)
            }
        }
        
        //need to check if this is a deep copy or not
        let originalPeopleSorted : [PFUser] = peopleSortedLowToHigh
        
        var choresToNumberOfPeople : Dictionary<PFObject, Int> = Dictionary<PFObject, Int>()
        for chore in choresSortedHighToLow {
            var numberOfPeopleAssigned : Int = 0
            for person in self.allUsers {
                if (person.objectForKey("currentChores") as NSArray).containsObject(chore.objectForKey("ID")) {
                    numberOfPeopleAssigned = numberOfPeopleAssigned + 1
                }
            }
            choresToNumberOfPeople[chore] = numberOfPeopleAssigned
        }
        
        //iterate through chores to actually assign them
        for chore in choresSortedHighToLow {
            var numberOfPeopleToAssign : Int = choresToNumberOfPeople[chore] as Int!
            //need to remove chore being assigned from all currently assigned users
            for person in self.allUsers {
                if (person.objectForKey("currentChores") as NSArray).containsObject(chore.objectForKey("ID")) {
                    var indexOfPerson : Int = find(person.objectForKey("currentChores") as [Int], chore.objectForKey("ID") as Int)!
                    var newArray : [Int] = person.objectForKey("currentChores") as [Int]
                    newArray.removeAtIndex(indexOfPerson)
                    person["currentChores"] = newArray
                    person.saveEventually()
                }
            }
            //in case you run out of people, cycle back around to make sure you have enough
            while numberOfPeopleToAssign > peopleSortedLowToHigh.count {
                peopleSortedLowToHigh += originalPeopleSorted
            }
            //add chore to person's currentChores
            for person in peopleSortedLowToHigh[0..<numberOfPeopleToAssign] {
                var newArray : [Int] = person.objectForKey("currentChores") as [Int]
                newArray.append(chore.objectForKey("ID") as Int)
                person["currentChores"] = newArray
                person.saveEventually()
            }
            //pop off that chore to move on to next one
            choresSortedHighToLow.removeAtIndex(0)
            var lengthOfSortedPeople : Int = peopleSortedLowToHigh.count
            
            //remove the number of people that you just assigned chores to
            for i in [0...lengthOfSortedPeople] {
                peopleSortedLowToHigh.removeAtIndex(0)
            }
        }
        
    }
    
    func tableView(tableView : UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Row " + String(indexPath.row) + " selected")
    }
    
    //need to have checkboxes be editable
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
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
