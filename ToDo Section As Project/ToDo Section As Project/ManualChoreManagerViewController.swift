////
////  ChoreManagerViewController.swift
////  ToDo Section As Project
////
////  Created by Tyler Finkelstein on 3/21/15.
////  Copyright (c) 2015 Tyler Finkelstein. All rights reserved.
////
//// Going to have this look the same as ToDoViewController. Differences include the right detail having only the names, and must be clickable as well in order to change the names. Points will be include in title or not included at all. Checkbox still there. Need to figure out this data thing so I don't have to copy paste data from one VC to this one.
//
//import UIKit
//
//class ManualChoreManagerViewController: UIViewController, UITableViewDataSource {
//
//    //need to add to this. nice to have feature? search for chores or people rather than having different sorting options
//    @IBOutlet var searchBar: UISearchBar!
//    
//    struct Person {
//        let name:String
//        let totalPoints:Int!
//        let currentChores:[Int];
//    }
//    
//    struct Chore {
//        let ID:Int!
//        let points:Int!
//        let description:String!
//        let doneOrNot:Bool!
//    }
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
//    var choreIDtoNameDictionary = Dictionary<Int, [String]>()
//    
//    func populateChoreIDtoPointsDictionary() {
//        for chore in chores {
//            choreIDtoPointsDictionary[chore.ID] = chore.points
//        }
//    }
//    
//    var choreDescriptions : [String] = []
//    
//    func populateChoreIDtoDescriptionDictionary() {
//        for chore in chores {
//            choreIDtoDescriptionDictionary[chore.ID] = chore.description
//        }
//        choreDescriptions = sorted(choreIDtoDescriptionDictionary.values, {$0 < $1})
//    }
//    
//    var choreDescriptionsToIDsDictionary = Dictionary<String, Int>()
//    
//    func populateChoreDescriptionsToIDsDictionary() {
//        for (key, value) in choreIDtoDescriptionDictionary {
//            choreDescriptionsToIDsDictionary[value] = key
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
//    func populateChoreIDtoNameDictionary() {
//        for chore in chores {
//            choreIDtoNameDictionary[chore.ID] = []
//        }
//        for chore in chores {
//            for person in people {
//                if contains(person.currentChores, chore.ID) {
//                    choreIDtoNameDictionary[chore.ID!] = choreIDtoNameDictionary[chore.ID!].append(person.name)
//                }
//            }
//        }
//    }
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
//    //Below three functions are for UITableViewDataSource
//    
//    //how many sections in the chores table = number of people
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        populateNameToChoreIDsDictionary()
//        populateChoreIDtoPointsDictionary()
//        populateChoreIDtoDescriptionDictionary()
//        populateChoreIDtoDoneOrNotDictionary()
//        populateChoreDescriptionsToIDsDictionary()
//        populateChoreIDtoNameDictionary()
//        return numberOfSections
//        //return 3
//    }
//    
//    //how many rows in each section = number of chores for a given person
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return choreDescriptions.count
//    }
//    
//    //contents of each cell = description of chores, points, people assigned to
//    //sorted by description A to Z
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
//        var choreNumberAlphabeticalByDescription : Int! = indexPath.row
//        var choreDescription : String = choreDescriptions[choreNumberAlphabeticalByDescription]
//        var choreID : Int! = choreDescriptionsToIDsDictionary[choreDescription]
//        var chorePoints : Int! = choreIDtoPointsDictionary[choreID]
//        println(choreIDtoDoneOrNotDictionary)
//        var choreDone : Bool! = choreIDtoDoneOrNotDictionary[choreID]
//        var peopleWithChore : [String]! = choreIDtoNameDictionary[choreID]
//        var peopleNamesStringToDisplay : String! = ""
//        for person in peopleWithChore {
//            //add a space if not first person in list
//            if peopleNamesStringToDisplay != "" {
//                peopleNamesStringToDisplay = peopleNamesStringToDisplay + ", " + person
//            } else {
//                peopleNamesStringToDisplay = peopleNamesStringToDisplay + person
//        }
//        cell.textLabel!.text! = choreDescription + String(" - Points: " + String(chorePoints))
//        cell.detailTextLabel!.text! = String(peopleNamesStringToDisplay)
//        
//        //want to access right detail, not checkbox
//        cell.detailTextLabel!.userInteractionEnabled = true
//        cell.detailTextLabel!.tag = indexPath.row
//        var tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TappedPeople:")
//        tapped.numberOfTapsRequired = 1
//        cell.detailTextLabel!.addGestureRecognizer(tapped)
//        
//        //if cell.accessoryType == UITableViewCellAccessoryType.None {
//        //    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        //} else {
//        //    cell.accessoryType = UITableViewCellAccessoryType.None
//        //}
//        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        //
//        return cell
//    }
//    
//    //change people who chore is assigned to
//        //needs to open up the people selector
//    func changeAssignment(cell : UITableViewCell) {
//        var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
//        var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
//        if cell.imageView!.image == checked_checkbox_image {
//            cell.imageView!.image = unchecked_checkbox_image
//        } else {
//            cell.imageView!.image = checked_checkbox_image
//        }
//    }
//    
//    //checks which checkbox was clicked
//    func TappedPeople(sender:UITapGestureRecognizer) {
//        //var imageView : UIImageView! = sender.view!
//        //var cell : UITableViewCell! = view.superview!
//        //println(sender.view!.tag)
//        println(sender.view!.tag) //gets us row number
//        //need to get the cell from sender info
//        //sender is the image
//        //sender.view!.backgroundColor = UIColor.redColor()
//        //sender.view!.hidden = true
//        //sender.view! = UIImage(named: "unchecked_checkbox")
//        //UIImageView *selectedImageView=(UIImageView*)[gesture view];
//        //var selectedImageView : UIImageView =
//        //changeCheckbox(sender)
//        //change chore to done or not done
//    }
//        
//    //gives table sections titles = person's name and points
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        //return person.name;
//        //return "Person's name - 66 Total Pointslklk;lkklkkiooiioiioioiiioioioio"
//        //return sectionTitles[indexPath.row]
//        return "Chores"
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
//}
