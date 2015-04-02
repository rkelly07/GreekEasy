//
//  ToDoViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 3/20/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    var allUsers : [PFUser] = []
    var allChores : [PFObject] = []
    var allEvents : [PFObject] = []
    var allReimbursements : [PFObject] = []
    var currentUser : PFUser = PFUser.currentUser()
    
    @IBOutlet var goToChoreManager: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(currentUser.objectForKey("houseID"))
        
        //get all users and add to allUsers array
        var usersQuery = PFQuery(className: "_User")
        usersQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        usersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.allUsers = objects as [PFUser]!
                println(self.allUsers)
//                for object in objects {
//                    self.allUsers.append(object as PFUser)
//                    println(object)
//                }
            } else {
                NSLog(error.description)
            }
        }
        
        var choresQuery = PFQuery(className: "ToDo")
        choresQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        choresQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allChores.append(object as PFObject)
                    //println(object)
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
                    //println(object)
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
                    //println(object)
                }
            } else {
                NSLog(error.description)
            }
        }

    }
    
    var sectionTitles : [String]! = []
    
    func populateSectionTitlesArray() {
        
        //println(self.allUsers)
        //println(self.allChores)
        
        for person in self.allUsers {
            println("self.allUsers is not empty")
            var firstName : String = person.objectForKey("firstName") as String
            var lastName : String = person.objectForKey("lastName") as String
            var fullName : String = firstName + " " + lastName
            self.sectionTitles.append(fullName)
        }
        self.sectionTitles.append("Fake Test User")
        self.sectionTitles = sorted(sectionTitles, {$0 < $1})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //how many sections in the chores table = number of people
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        populateSectionTitlesArray()
        println("Number of sections is " + String(sectionTitles.count))
        //return sectionTitles.count
        return 1
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
        //TODO I don't know if this userForSection declaration is okay
        var userForSection : PFUser = PFUser()
        var userFullName : String = sectionTitles[section]
        userForSection = findUserByFullName(userFullName)
        
        //TODO check if userForSection is nil
//        if userForSection == nil as PFUser() {
//            println("user wasn't found")
//        }
        
        var userChores : [Int] = []
        //userChores = userForSection.objectForKey("currentChores") as [Int]
        //return userChores.count

        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        //TODO I don't know if this userForSection declaration is okay
//        var userForSection : PFUser = PFUser()
//        var userFullName : String = sectionTitles[indexPath.section]
//        userForSection = findUserByFullName(userFullName)
//
//        var userChores : [Int] = []
//        userChores = userForSection.objectForKey("currentChores") as [Int]
//        var specificChoreID : Int = userChores[indexPath.row]
//        //TODO I don't know if this userForSection declaration is okay
//        var specificChore : PFObject = PFObject()
//        
//        
//        var findChore = PFQuery(className: "ToDo")
//        findChore.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
//        findChore.whereKey("choreID", equalTo:specificChoreID)
//        findChore.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]!, error: NSError!) -> Void in
//            if error == nil {
//                for object in objects {
//                    specificChore = object as PFObject
//                    //println(object)
//                }
//            } else {
//                NSLog(error.description)
//            }
//        }
//        
//        var choreTitle : String = specificChore.objectForKey("description") as String
//        var chorePoints : Int = specificChore.objectForKey("points") as Int
//        //TODO should this be Bool or Boolean?
//        var choreStatus : Bool = specificChore.objectForKey("doneOrNot") as Bool
//        var otherPeopleOnChore : [PFUser] = []
//        
//        //go through other users and see who has the same choreID
//        for person in self.allUsers {
//            if (person.objectForKey("currentChores") as NSArray).containsObject(specificChoreID) {
//                otherPeopleOnChore.append(person)
//            }
//        }
//        
//        var otherPeopleFullNames : [String] = []
//        for person in otherPeopleOnChore {
//            var personFirstName : String = person.objectForKey("firstName") as String
//            var personLastName : String = person.objectForKey("lastName") as String
//            otherPeopleFullNames.append(personFirstName + " " + personLastName)
//        }
//        var otherPeopleNamesString : String = ""
//        for name in otherPeopleFullNames {
//            if otherPeopleNamesString == "" {
//                otherPeopleNamesString = otherPeopleNamesString + name
//            } else {
//                otherPeopleNamesString = otherPeopleNamesString + ", " + name
//            }
//        }
//        //TODO if otherPeopleFullNames is empty that label shouldn't be displayed and cell resized
//        
//        (cell.contentView.viewWithTag(11) as UILabel).text = choreTitle
//        (cell.contentView.viewWithTag(11) as UILabel).font = UIFont.boldSystemFontOfSize(18.0)
//        (cell.contentView.viewWithTag(12) as UILabel).text = "test"
//        (cell.contentView.viewWithTag(13) as UILabel).text = otherPeopleNamesString
//        
//        var buttonInCell : UIButton = (cell.contentView.viewWithTag(111) as UIButton)
//        var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
//        var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
//        if choreStatus == true {
//            buttonInCell.setImage(checked_checkbox_image, forState: .Normal)
//        } else {
//            buttonInCell.setImage(unchecked_checkbox_image, forState: .Normal)
//        }
        
        (cell.contentView.viewWithTag(11) as UILabel).text = "test"
        (cell.contentView.viewWithTag(11) as UILabel).font = UIFont.boldSystemFontOfSize(18.0)
        (cell.contentView.viewWithTag(12) as UILabel).text = "test"
        (cell.contentView.viewWithTag(13) as UILabel).text = "other peeps"
        
        return cell
    }
    
    @IBAction func changeChoreState(sender: AnyObject) {
        println("Button press works")
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(position)!
        println(indexPath.section)
        println(indexPath.row)
        var choreNumberForIndividual : Int! = indexPath.row
        var userForSection : PFUser = PFUser()
        var userFullName : String = sectionTitles[indexPath.section]
        userForSection = findUserByFullName(userFullName)
        
        var userChores : [Int] = []
        userChores = userForSection.objectForKey("currentChores") as [Int]
        var specificChoreID : Int = userChores[indexPath.row]
        //TODO I don't know if this userForSection declaration is okay
        var specificChore : PFObject = PFObject()

        var findChore = PFQuery(className: "ToDo")
        findChore.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        findChore.whereKey("choreID", equalTo:specificChoreID)
        findChore.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    specificChore = object as PFObject
                    //println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var choreStatus : Bool = specificChore.objectForKey("doneOrNot") as Bool
        
        //change chorestatus - need to make sure this saves on parse
        if choreStatus == false {
            choreStatus = true
        } else {
            choreStatus = false
        }
        specificChore.saveEventually()
    }
    
    
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

//import UIKit
//
//class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    @IBOutlet var tableView: UITableView!
//    @IBOutlet var goToSecondSBButton: UIButton!
//    @IBOutlet var goToChoreManagerButton: UIButton!
//    @IBOutlet var goToPointsLeaderboardButton: UIButton!
//    
//    @IBAction func changeState(sender: AnyObject) {
//        println("change checkbox please")
//        //var cell : UITableViewCell = sender.cellForRowAtIndexPath(indexPath: NSIndexPath)
//        //cell.backgroundColor = UIColor.redColor()
//        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
//        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(position)!
//        println(indexPath.section)
//        println(indexPath.row)
//        var personName : String! = sectionTitles[indexPath.section]
//        var choreNumberForIndividual : Int! = indexPath.row
//        for person in people {
//            if person.name == personName {
//                println("person's name")
//                println(personName)
//                var specificChoreID : Int! = person.currentChores[choreNumberForIndividual]
//                println("chore id")
//                println(specificChoreID)
//                if choreIDtoDoneOrNotDictionary[specificChoreID] == true {
//                    for chore in chores {
//                        if chore.ID == specificChoreID {
//                            //chore.doneOrNot = false
//                            //what if two people have same chore? mark done for both?
//                            //here we want to change state but can't because it's a struct
//                        }
//                    }
//                    populateChoreIDtoDoneOrNotDictionary()
//                } else {
//                    println("chore is not done")
//                }
//            }
//        }
//    
//    struct Person {
//        let name:String!
//        let totalPoints:Int!
//        let currentChores:[Int!];
//    }
//    
//    struct Chore {
//        let ID:Int!
//        let points:Int!
//        let description:String!
//        var doneOrNot:Bool!
//    }
//    
//        
//    
//    var chores : [Chore]! = [
//        Chore(ID: 0, points: 25, description: "6.005", doneOrNot: false),
//        Chore(ID: 1, points: 3, description: "Bring desktop upstairs", doneOrNot: true),
//        Chore(ID: 2, points: 1, description: "Pledge test", doneOrNot: false),
//        Chore(ID: 3, points: 10, description: "Buy a 6 pack for next class", doneOrNot: false),
//        Chore(ID: 4, points: 10, description: "Number 1", doneOrNot: false),
//        Chore(ID: 5, points: 10, description: "Number 2", doneOrNot: false),
//        Chore(ID: 6, points: 10, description: "Number 3", doneOrNot: false),
//    ]
//    
//    var choreIDtoPointsDictionary = Dictionary<Int, Int>()
//    var choreIDtoDescriptionDictionary = Dictionary<Int, String>()
//    var choreIDtoDoneOrNotDictionary = Dictionary<Int, Bool>()
//    
//    func populateChoreIDtoPointsDictionary() {
//        for chore in chores {
//            choreIDtoPointsDictionary[chore.ID] = chore.points
//        }
//    }
//    
//    func populateChoreIDtoDescriptionDictionary() {
//        for chore in chores {
//            choreIDtoDescriptionDictionary[chore.ID] = chore.description
//        }
//    }
//    
//    func populateChoreIDtoDoneOrNotDictionary() {
//        for chore in chores {
//            choreIDtoDoneOrNotDictionary[chore.ID] = chore.doneOrNot
//        }
//    }
//    
//    var people : [Person]! = [
//        Person(name: "Drew", totalPoints: 10, currentChores: [0]),
//        Person(name: "Ryan", totalPoints: 300, currentChores: [1,2]),
//        Person(name: "Tyler", totalPoints: 25, currentChores: [3]),
//        Person(name: "Diits", totalPoints: 0, currentChores: [4,5,6])
//    ]
//    
//    var numberOfSections:Int = 1
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //each section is for a person
//    //within each section is that person's chores
//    class Section {
//        var sectionName: [String] = []
//        var userChores: [Chore] = []
//    }
//    
//    let collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
//    var sections = [Section]()
//    
//    //initializing dictionary to map section headers (person's name) to that person's chores
//    var NameToChoreIDsDictionary = Dictionary<String, Array<Int>>()
//    
//    func populateNameToChoreIDsDictionary() {
//        for person in people {
//            var choreIDs : [Int]! = []
//            for chore in person.currentChores {
//                //println(chore)
//                choreIDs.append(chore)
//                //println(choreIDs)
//            }
//            NameToChoreIDsDictionary[person.name] = choreIDs
//        }
//    }
//    
//    var sectionTitles : [String]! = []
//    func populateSectionTitlesArray() {
//        for (key, value) in NameToChoreIDsDictionary {
//            //println("Entering")
//            sectionTitles.append(key)
//        }
//        sectionTitles = sorted(sectionTitles, {$0 < $1})
//    }
//    
//    //Below three functions are for UITableViewDataSource
//    
//    //how many sections in the chores table = number of people
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        populateNameToChoreIDsDictionary()
//        populateSectionTitlesArray()
//        populateChoreIDtoPointsDictionary()
//        populateChoreIDtoDescriptionDictionary()
//        populateChoreIDtoDoneOrNotDictionary()
//        return sectionTitles.count
//        //return 3
//    }
//    
//    //how many rows in each section = number of chores for a given person
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var personName : String! = sectionTitles[section]
//        var choreIDs : [Int]! = NameToChoreIDsDictionary[personName]
//        return choreIDs.count
//    }
//    
//    //contents of each cell = description of chores for a given person and number of points
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
//
//    //gives table sections titles = person's name and points
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "title"
//    }
//    
//    //says you can edit a cell in the table. Only true if role = house manager
//    //need to have checkboxes be editable
//    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
//        return true
//    }
//    
//    //removes data from array and updates table view when deleting
//    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            // remove data from array and udpate tableview
//        }
//    }
//    
//}
