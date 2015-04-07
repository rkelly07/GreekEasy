//
//  ToDoDetailViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var choreObject : PFObject!
    var choreID : Int!
    var originalChoreTitle : String! = ""
    var chorePoints : Int! = 0
    var allUsers : [PFUser]! = []
    var allUsersFullNames : [String]! = []
    var peopleOnChore : [PFUser] = []
    var peopleOriginallyOnChore : [PFUser] = []
    var selectedPeople : [Int] = []
    var selectedPoints : Int = 0
    
    var editingNotAdding : Bool = true //true if editing, false if adding
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var pointsPickerView: UIPickerView!
    @IBOutlet var peopleTable: UITableView!
    
    //let maxPoints : Int = 100
    let pointsArray : [Int] = Array(0...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pointsPickerView.dataSource = self
        self.pointsPickerView.delegate = self
        self.pointsPickerView.selectRow(self.chorePoints, inComponent: 0, animated: true)
        populateUserFullNamesArray()
        self.titleTextField.text = self.originalChoreTitle
    }
    
    func populateUserFullNamesArray() {
        for person in self.allUsers {
            //println("self.allUsers is not empty")
            var firstName : String = person.objectForKey("firstName") as String
            var lastName : String = person.objectForKey("lastName") as String
            var fullName : String = firstName + " " + lastName
            self.allUsersFullNames.append(fullName)
            //println(fullName)
        }
        self.allUsersFullNames = sorted(self.allUsersFullNames, {$0 < $1})
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUsersFullNames.count
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
    
    func getUserChoresString(userOb: PFObject) -> String {
        var choreDescripsString : String = ""
//        var userChores : [Int] = []
//        userChores = userOb.objectForKey("currentChores") as [Int]
//        //println(userOb.objectForKey("firstName"))
//        //println(userChores)
//        for choreNumber in userChores {
//            //println("entered iteration through choreNumbers")
//            //println(choreNumber)
//            var choreQuery = PFQuery(className: "ToDo")
//            choreQuery.whereKey("ID", equalTo:choreNumber)
//            choreQuery.findObjectsInBackgroundWithBlock {
//                (objects: [AnyObject]!, error: NSError!) -> Void in
//                //println("Matches are ")
//                if error == nil {
//                    //println("looking for " + String(choreNumber))
//                    for object in objects {
//                        println("iterating through objects")
//                        if choreDescripsString == "" {
//                            choreDescripsString = choreDescripsString + (object.objectForKey("description") as String)
//                        } else {
//                            choreDescripsString = choreDescripsString + ", " + (object.objectForKey("description") as String)
//                        }
//                    }
//                } else {
//                    NSLog(error.description)
//                }
//                //println("After adding this, string is " + choreDescripsString)
//            }
//        }
        //println("End string for user is: " + choreDescripsString)
        choreDescripsString = "Balls this don't work"
        return choreDescripsString
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        var userFullName : String = self.allUsersFullNames[indexPath.row]
        println("Looking at row for " + userFullName)
        var userPF : PFUser = findUserByFullName(userFullName)
        var userPoints : Int = userPF.objectForKey("totalPoints") as Int
        var userChores : [Int] = []
        var userChoresAsString = getUserChoresString(userPF)
        //println("String of chores for user is " + String(userChoresAsString))
        
        //TODO if otherPeopleFullNames is empty that label shouldn't be displayed and cell resized
        //temporary solution for too long titles
        var numChars : Int = 25
        if countElements(self.titleTextField.text) > numChars {
            self.titleTextField.text = (self.titleTextField.text as NSString).substringToIndex(numChars) + String("...")
        }
        if countElements(userChoresAsString) > numChars {
            userChoresAsString = (userChoresAsString as NSString).substringToIndex(numChars) + String("...")
        }
        
        (cell.contentView.viewWithTag(11) as UILabel).text = userFullName
        (cell.contentView.viewWithTag(11) as UILabel).font = UIFont.boldSystemFontOfSize(18.0)
        (cell.contentView.viewWithTag(12) as UILabel).text = "Points: " + String(userPoints)
        (cell.contentView.viewWithTag(13) as UILabel).text = userChoresAsString
        
        var buttonInCell : UIButton = (cell.contentView.viewWithTag(111) as UIButton)
        var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
        var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
        if contains(self.peopleOnChore, userPF) {
            println("Chore is currently assigned to " + userFullName)
            buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
        } else {
            println("Chore is not currently assigned to " + userFullName)
            buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
        }
        return cell
    }
    
    @IBAction func goBackWithoutMakingOrEditingChore(sender: AnyObject) {
        if editingNotAdding {
            self.choreObject["description"] = self.originalChoreTitle
            self.choreObject["points"] = selectedPoints
            //if you hit back, you only want the original users to have the chore assigned to them
            for user in self.allUsers {
                if contains(user.objectForKey("currentChores") as [Int], self.choreID) {
                    var indexOfChore : Int = find(user.objectForKey("currentChores") as [Int], self.choreID)!
                    var newArray : [Int] = (user.objectForKey("currentChores") as [Int])
                    newArray.removeAtIndex(indexOfChore)
                    user["currentChores"] = newArray
                }
                if contains(self.peopleOriginallyOnChore, user) {
                    var newArray : [Int] = (user.objectForKey("currentChores") as [Int])
                    newArray.append(self.choreID)
                    user["currentChores"] = newArray
                }
            }
        } else {
            println("User went back after beginning to add chore. Nothing should happen because chore was never created")
        }
    }
    
    @IBAction func addOrRemovePersonFromChore(sender: AnyObject) {
        println("Button press works")
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.peopleTable)
        var indexPath: NSIndexPath = self.peopleTable.indexPathForRowAtPoint(position)!
        var personNumberInTable : Int! = indexPath.row
        var user : PFUser = PFUser()
        var userFullName : String = self.allUsersFullNames[indexPath.row]
        println("Trying to select/deselect " + userFullName)
        var userPF : PFUser = findUserByFullName(userFullName)
        var userCurrentlyAssignedToChore : Bool = false
        
        if contains(userPF.objectForKey("currentChores") as [Int], self.choreID) {
            userCurrentlyAssignedToChore = true
        }
        
        if userCurrentlyAssignedToChore {
            var indexOfChore : Int = find(userPF.objectForKey("currentChores") as [Int], self.choreID)!
            var newArray : [Int] = (userPF.objectForKey("currentChores") as [Int])
            println("Old chores for person are ")
            println(newArray)
            newArray.removeAtIndex(indexOfChore)
            println("New chores for person are ")
            println(newArray)
            userPF["currentChores"] = newArray
            println("Actually assigned in parse are ")
            println((userPF.objectForKey("currentChores") as [Int]))
            var indexOfPerson : Int = find(self.peopleOnChore, userPF)!
            self.peopleOnChore.removeAtIndex(indexOfPerson)
            userPF.saveEventually()
            self.peopleTable.reloadData()
            //TODO update to new array without chore
        } else {
            var newArray : [Int] = (userPF.objectForKey("currentChores") as [Int])
            //println(newArray)
            newArray.append(choreID)
            //println("New chores for person are ")
            //println(newArray)
            userPF["currentChores"] = newArray
            //println("Actually assigned in parse are ")
            //println((userPF.objectForKey("currentChores") as [Int]))
            self.peopleOnChore.append(userPF)
            userPF.saveEventually()
            self.peopleTable.reloadData()
        }
        userPF.saveEventually()
    }
    
    @IBAction func saveEditedChore(sender: AnyObject) {
        //query using choreid to get object
        println("trying to save chore")
        self.choreObject["description"] = self.titleTextField.text as String //don't know if this works
        self.choreObject["points"] = self.selectedPoints as Int
        //        var userChores : [Int] = []
        //        for user in self.allUsers {
        //            userChores = (user.objectForKey("currentChores") as [Int])
        //            if contains(userChores,self.choreID) {
        //
        //            }
        //save chore
        self.choreObject.saveEventually()
        for user in self.allUsers {
            user.saveEventually()
        }
        self.performSegueWithIdentifier("goBackAfterSavingOrEditing", sender: nil)
    }
    
    //TODO make @IBAction
    func createNewChore(sender: AnyObject) {
        var newChore : PFObject = PFObject(className: "ToDo")
        newChore["ID"] = self.choreID as Int
        newChore["points"] = self.selectedPoints as Int
        newChore["description"] = self.titleTextField.text as String
        newChore.saveEventually()
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pointsArray.count
    }
    
    //MARK: Delegates
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(pointsArray[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPoints = row
        println("Chore is worth " + String(selectedPoints) + " points")
    }
}