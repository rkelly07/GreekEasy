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
    var choreTitle : String!
    var chorePoints : Int!
    var allUsers : [PFUser]! = []
    var allUsersFullNames : [String]! = []
    var peopleOnChore : [PFUser] = []
    var selectedPeople : [Int] = []
    var selectedPoints : Int = 0
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var pointsPickerView: UIPickerView!
    @IBOutlet var peopleTable: UITableView!
    
    //let maxPoints : Int = 100
    let pointsArray : [Int] = Array(0...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsPickerView.dataSource = self
        pointsPickerView.delegate = self
        //peoplePickerView.dataSource = self
        //peoplePickerView.delegate = self
        pointsPickerView.selectRow(chorePoints - 1, inComponent: 0, animated: true)
        pointsPickerView.selectRow(chorePoints, inComponent: 0, animated: true)
        populateUserFullNamesArray()
        titleTextField.text = self.choreTitle
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
        return allUsersFullNames.count
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        var userFullName : String = self.allUsersFullNames[indexPath.row]
        println("Looking at row for " + userFullName)
        var userPF : PFUser = findUserByFullName(userFullName)
        var userPoints : Int = userPF.objectForKey("totalPoints") as Int
        var userChores : [Int] = []
        userChores = userPF.objectForKey("currentChores") as [Int]
        println(userChores)
        var userChoresAsString : String = ""
        for chore in userChores {
            println(chore)
            var choreQuery = PFQuery(className: "ToDo")
            choreQuery.whereKey("ID", equalTo:chore)
            choreQuery.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                println("Matches are ")
                println(objects)
                for object in objects {
                    if error == nil {
                        if userChoresAsString == "" {
                            userChoresAsString = userChoresAsString + (object.objectForKey("description") as String)
                        } else {
                            userChoresAsString = userChoresAsString + ", " + (object.objectForKey("description") as String)
                        }
                    } else {
                        NSLog(error.description)
                    }
                }
            }
        }
        println("String of chores for user is ")
        println(userChoresAsString)
        
        //TODO if otherPeopleFullNames is empty that label shouldn't be displayed and cell resized
        //temporary solution for too long titles
        var numChars : Int = 25
        if countElements(choreTitle) > numChars {
            choreTitle = (choreTitle as NSString).substringToIndex(numChars) + String("...")
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
        if contains(peopleOnChore, userPF) {
            println("Chore is assigned to " + userFullName)
            buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
        } else {
            println("Chore is not assigned to " + userFullName)
            buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
        }
        
        return cell
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
            //println("Old chores for person are ")
            //println(newArray)
            newArray.removeAtIndex(indexOfChore)
            //println("New chores for person are ")
            //println(newArray)
            //println(newArray)
            userPF["currentChores"] = newArray
            //println("Actually assigned in parse are ")
            //println((userPF.objectForKey("currentChores") as [Int]))
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
            self.peopleTable.reloadData()
        }
        userPF.saveEventually()
    }

    @IBAction func saveEditedChore(sender: AnyObject) {
        //query using choreid to get object
        self.choreObject["description"] = self.choreTitle //don't know if this works
        self.choreObject["points"] = selectedPoints
//        var userChores : [Int] = []
//        for user in self.allUsers {
//            userChores = (user.objectForKey("currentChores") as [Int])
//            if contains(userChores,self.choreID) {
//                
//            }
        //save chore
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
        selectedPoints = row
        println("Chore is worth " + String(selectedPoints) + " points")
    }
}
