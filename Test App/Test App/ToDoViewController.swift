//
//  ToDoViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 3/20/15.
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
    
    // MARK: - Table view data source
    
    //    //how many rows in each section = number of chores for a given person
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        var personName : String! = sectionTitles[section]
    //        var choreIDs : [Int]! = NameToChoreIDsDictionary[personName]
    //        return choreIDs.count
    //    }
    
    //how many sections in the chores table = number of people
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        populateSectionTitlesArray()
        return sectionTitles.count
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
        return userChores.count
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
