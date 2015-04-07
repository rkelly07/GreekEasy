//
//  ToDoDetailViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    var allChores : [PFObject] = []
    
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
        //self.pointsPickerView.frame = CGRectMake(0,0,100,20)
        self.peopleTable.flashScrollIndicators()
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Allows text field to be exited after entering text
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUsersFullNames.count
    }
    
    func findUserByFullName(userFullName : String) -> PFUser {
        //var userForSection : PFUser = PFUser()
        for user in self.allUsers {
            if ((user.objectForKey("firstName") as String) + " " + (user.objectForKey("lastName") as String)) == userFullName {
                return user
            }
        }
        return PFUser()
        //return userForSection
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
        self.performSegueWithIdentifier("goBackAfterSavingOrEditing", sender: nil)
    }
    
    @IBAction func addOrRemovePersonFromChore(sender: AnyObject) {
        println("Button press works")
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.peopleTable)
        var indexPath: NSIndexPath = self.peopleTable.indexPathForRowAtPoint(position)!
        var personNumberInTable : Int! = indexPath.row
        var userFullName : String = self.allUsersFullNames[indexPath.row]
        println("Trying to select/deselect " + userFullName)
        var userPF : PFUser = findUserByFullName(userFullName)
        
        if contains(self.peopleOnChore, userPF) {
            var indexOfPerson : Int = find(self.peopleOnChore, userPF)!
            self.peopleOnChore.removeAtIndex(indexOfPerson)
            println("user removed")
            println(self.peopleOnChore)
            self.peopleTable.reloadData()
        } else {
            self.peopleOnChore.append(userPF)
            println("user added")
            println(self.peopleOnChore)
            self.peopleTable.reloadData()
        }
    }
    
    @IBAction func saveEditedChore(sender: AnyObject) {
        //editing a chore
        if (self.editingNotAdding) {
            //query using choreid to get object
            println("trying to save chore")
            self.choreObject["description"] = self.titleTextField.text as String //don't know if this works
            self.choreObject["points"] = self.selectedPoints as Int
            self.choreObject["doneOrNot"] = false as Bool
            self.choreObject.saveEventually()
            println("ALL USER ALL USER ALL USER")
            println(self.allUsers)
            var objectIDArray : [String] = ["oRX5yxm5fI","IuqUfyaFGz","eq8p3uvm16","yZwRKbDuCO"]
            
            for objectID in objectIDArray {
                var query = PFQuery(className:"_User")
                query.getObjectInBackgroundWithId(objectID) {
                    (object: PFObject!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        println("OBJECT RETRIEVED RETRIEVED")
                        println(objectID)
                        println(object)
                        object["currentChores"] = [2]
                        object.save()
                        self.peopleTable.reloadData()
                        //object.saveEventually()
                    }
                }
            }
//            for user in self.allUsers {
//                println("EDITING EDITING EDITING")
//                println(user)
//                //user.saveEventually()
//                var objectIDOfUser : String
//                objectIDOfUser = user.objectId //"oRX5yxm5fI"
//                var userFullName : String
//                println("OBJECT ID OBJECT ID OBJECT ID")
//                println(objectIDOfUser)
//                //var objectIDOfUser : String = user.objectForKey("_objectId") as String
//                self.peopleTable.reloadData()
////                var query = PFQuery(className:"_User")
////                query.whereKey("_objectId",equalTo: objectIDOfUser)
////                query.findObjects
////                query.findObjectsInBackgroundWithBlock {
////                    (objects: [AnyObject]!, error: NSError!) -> Void in
////                    if error == nil {
////                        println("Inside find objects block")
////                        for object in objects {
////                            (object as PFUser)["currentChores"] = [2]
////                        }
////                    } else {
////                        NSLog(error.description)
////                    }
////                }
//                query.getObjectInBackgroundWithId(objectIDOfUser) {
//                    (object: PFUser!, error: NSError!) -> Void in
//                    if error != nil {
//                        println(error)
//                    } else {
//                        println("OBJECT RETRIEVED RETRIEVED")
//                        println(object)
//                        object["currentChores"] = [2]
//                        object.saveEventually()
//                    }
//                }
////                println("all users are ")
////                println(self.allUsers)
////                //if people on chore doesn't contains user but user's choreslist contains choreID -> remove
////                if !contains(self.peopleOnChore, user) {
////                    if contains(user.objectForKey("currentChores") as [Int], self.choreID) {
////                        println(user.objectForKey("currentChores"))
////                        user.removeObject(self.choreID, forKey:"currentChores")
////                        println("Actually assigned in parse are ")
////                        println((user.objectForKey("currentChores") as [Int]))
////                        user.saveEventually()
////                        //self.peopleTable.reloadData()
////                    }
////                //if people on chore does contains user but user's choreslist doesn't contains choreID -> add
////                } else if contains(self.peopleOnChore, user) {
////                    if !contains(user.objectForKey("currentChores") as [Int], self.choreID) {
////                        println(user.objectForKey("currentChores"))
////                        user.addObject(self.choreID, forKey:"currentChores")
////                        println("Actually assigned in parse are ")
////                        println((user.objectForKey("currentChores") as [Int]))
////                        user.saveEventually()
////                        //self.peopleTable.reloadData()
////                    }
////                }
//            }
            self.performSegueWithIdentifier("goBackAfterSavingOrEditing", sender: nil)
            self.peopleTable.reloadData()
        //adding a new chore
        } else {
            println("You're trying to add a new chore ")
            var newChore : PFObject = PFObject(className: "ToDo")
            newChore["ID"] = self.choreID as Int
            newChore["points"] = self.selectedPoints as Int
            newChore["description"] = self.titleTextField.text as String
            newChore["doneOrNot"] = false as Bool
            newChore["houseID"] = PFUser.currentUser().objectForKey("houseID") as Int
            newChore.saveEventually()
            //because chore is new, we know no one is assigned to it yet
            for user in self.peopleOnChore {
                var newArray : [Int] = (user.objectForKey("currentChores") as [Int])
                //println(newArray)
                newArray.append(choreID)
                //println("New chores for person are ")
                //println(newArray)
                user["currentChores"] = newArray
                //println("Actually assigned in parse are ")
                //println((userPF.objectForKey("currentChores") as [Int]))
                user.saveEventually()
                self.peopleTable.reloadData()
            }
            self.performSegueWithIdentifier("goBackAfterSavingOrEditing", sender: nil)
            self.peopleTable.reloadData()
        }
    }
    
//    @IBAction func saveEditedChore(sender: AnyObject) {
//        //editing a chore
//        if (self.editingNotAdding) {
//            //query using choreid to get object
//            println("trying to save chore")
//            self.choreObject["description"] = self.titleTextField.text as String //don't know if this works
//            self.choreObject["points"] = self.selectedPoints as Int
//            self.choreObject["doneOrNot"] = false as Bool
//            self.choreObject.saveEventually()
//            
//            for user in self.allUsers {
//                println("all users are ")
//                println(self.allUsers)
//                //if people on chore doesn't contains user but user's choreslist contains choreID -> remove
//                if !contains(self.peopleOnChore, user) {
//                    if contains(user.objectForKey("currentChores") as [Int], self.choreID) {
//                        var indexOfChore : Int = find(user.objectForKey("currentChores") as [Int], self.choreID)!
//                        var newArray : [Int] = (user.objectForKey("currentChores") as [Int])
//                        println("Old chores for person are ")
//                        println(newArray)
//                        newArray.removeAtIndex(indexOfChore)
//                        println("New chores for person are ")
//                        println(newArray)
//                        user["currentChores"] = newArray
//                        //user["currentChores"] = [11]
//                        println("Actually assigned in parse are ")
//                        println((user.objectForKey("currentChores") as [Int]))
//                        user.saveEventually()
//                        //self.peopleTable.reloadData()
//                    }
//                    //if people on chore does contains user but user's choreslist doesn't contains choreID -> add
//                } else if contains(self.peopleOnChore, user) {
//                    if !contains(user.objectForKey("currentChores") as [Int], self.choreID) {
//                        var newArray : [Int] = (user.objectForKey("currentChores") as [Int])
//                        //println(newArray)
//                        newArray.append(choreID)
//                        //println("New chores for person are ")
//                        //println(newArray)
//                        user["currentChores"] = newArray
//                        //println("Actually assigned in parse are ")
//                        //println((userPF.objectForKey("currentChores") as [Int]))
//                        user.saveEventually()
//                        //self.peopleTable.reloadData()
//                    }
//                }
//            }
//            self.performSegueWithIdentifier("goBackAfterSavingOrEditing", sender: nil)
//            self.peopleTable.reloadData()
//            //adding a new chore
//        } else {
//            println("You're trying to add a new chore ")
//            var newChore : PFObject = PFObject(className: "ToDo")
//            newChore["ID"] = self.choreID as Int
//            newChore["points"] = self.selectedPoints as Int
//            newChore["description"] = self.titleTextField.text as String
//            newChore["doneOrNot"] = false as Bool
//            newChore["houseID"] = PFUser.currentUser().objectForKey("houseID") as Int
//            newChore.saveEventually()
//            //because chore is new, we know no one is assigned to it yet
//            for user in self.peopleOnChore {
//                var newArray : [Int] = (user.objectForKey("currentChores") as [Int])
//                //println(newArray)
//                newArray.append(choreID)
//                //println("New chores for person are ")
//                //println(newArray)
//                user["currentChores"] = newArray
//                //println("Actually assigned in parse are ")
//                //println((userPF.objectForKey("currentChores") as [Int]))
//                user.saveEventually()
//                self.peopleTable.reloadData()
//            }
//            self.performSegueWithIdentifier("goBackAfterSavingOrEditing", sender: nil)
//            self.peopleTable.reloadData()
//        }
//    }
    
//    //TODO make @IBAction
//    func createNewChore(sender: AnyObject) {
//        var newChore : PFObject = PFObject(className: "ToDo")
//        newChore["ID"] = self.choreID as Int
//        newChore["points"] = self.selectedPoints as Int
//        newChore["description"] = self.titleTextField.text as String
//        newChore.saveEventually()
//    }
    
    
    
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