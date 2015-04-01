//
//  ToDoViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 3/20/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var goToSecondSBButton: UIButton!
    @IBOutlet var goToChoreManagerButton: UIButton!
    @IBOutlet var goToPointsLeaderboardButton: UIButton!
    
//    let secondSB : UIStoryboard = UIStoryboard(name: "SecondStoryboard.storyboard", bundle: nil)
//    let secondVC = secondSB!.instantiateInitialViewController() as UIViewController
    
    let secondVC:UIViewController = UIStoryboard(name: "SecondStoryboard", bundle:nil).instantiateViewControllerWithIdentifier("numberTwo") as UIViewController
    
    @IBAction func changeStoryBoardButtonClicked(sender: AnyObject) {
        presentViewController(secondVC, animated: false, completion: nil)
    }
    
    @IBAction func choreManagerButtonClicked(sender: AnyObject) {
        println("chore manager clicked")
    }
    
    struct Person {
        let name:String!
        let totalPoints:Int!
        let currentChores:[Int!];
    }
    
    struct Chore {
        let ID:Int!
        let points:Int!
        let description:String!
        let doneOrNot:Bool!
    }
    
    var chores : [Chore]! = [
        Chore(ID: 0, points: 25, description: "6.005", doneOrNot: false),
        Chore(ID: 1, points: 3, description: "Bring desktop upstairs", doneOrNot: true),
        Chore(ID: 2, points: 1, description: "Pledge test", doneOrNot: false),
        Chore(ID: 3, points: 10, description: "Buy a 6 pack for next class", doneOrNot: false),
        Chore(ID: 4, points: 10, description: "Number 1", doneOrNot: false),
        Chore(ID: 5, points: 10, description: "Number 2", doneOrNot: false),
        Chore(ID: 6, points: 10, description: "Number 3", doneOrNot: false),
    ]
    
    var choreIDtoPointsDictionary = Dictionary<Int, Int>()
    var choreIDtoDescriptionDictionary = Dictionary<Int, String>()
    var choreIDtoDoneOrNotDictionary = Dictionary<Int, Bool>()
    
    func populateChoreIDtoPointsDictionary() {
        for chore in chores {
            choreIDtoPointsDictionary[chore.ID] = chore.points
        }
    }
    
    func populateChoreIDtoDescriptionDictionary() {
        for chore in chores {
            choreIDtoDescriptionDictionary[chore.ID] = chore.description
        }
    }
    
    func populateChoreIDtoDoneOrNotDictionary() {
        for chore in chores {
            choreIDtoDoneOrNotDictionary[chore.ID] = chore.doneOrNot
        }
    }
    
    var people : [Person]! = [
        Person(name: "Drew", totalPoints: 10, currentChores: [0]),
        Person(name: "Ryan", totalPoints: 300, currentChores: [1,2]),
        Person(name: "Tyler", totalPoints: 25, currentChores: [3]),
        Person(name: "Diits", totalPoints: 0, currentChores: [4,5,6])
    ]
    
    var numberOfSections:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //each section is for a person
    //within each section is that person's chores
    class Section {
        var sectionName: [String] = []
        var userChores: [Chore] = []
    }
    
    let collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
    var sections = [Section]()
    
    //initializing dictionary to map section headers (person's name) to that person's chores
    var NameToChoreIDsDictionary = Dictionary<String, Array<Int>>()
    
    func populateNameToChoreIDsDictionary() {
        for person in people {
            var choreIDs : [Int]! = []
            for chore in person.currentChores {
                //println(chore)
                choreIDs.append(chore)
                //println(choreIDs)
            }
            NameToChoreIDsDictionary[person.name] = choreIDs
        }
    }
    
    var sectionTitles : [String]! = []
    func populateSectionTitlesArray() {
        for (key, value) in NameToChoreIDsDictionary {
            //println("Entering")
            sectionTitles.append(key)
        }
        sectionTitles = sorted(sectionTitles, {$0 < $1})
    }
    
    //Below three functions are for UITableViewDataSource
    
    //how many sections in the chores table = number of people
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        populateNameToChoreIDsDictionary()
        populateSectionTitlesArray()
        populateChoreIDtoPointsDictionary()
        populateChoreIDtoDescriptionDictionary()
        populateChoreIDtoDoneOrNotDictionary()
        return sectionTitles.count
        //return 3
    }
    
    //how many rows in each section = number of chores for a given person
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var personName : String! = sectionTitles[section]
        var choreIDs : [Int]! = NameToChoreIDsDictionary[personName]
        return choreIDs.count
    }
    
    //contents of each cell = description of chores for a given person and number of points
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        var personName : String! = sectionTitles[indexPath.section]
        var choreNumberForIndividual : Int! = indexPath.row
        var choreID : Int! = NameToChoreIDsDictionary[personName]![choreNumberForIndividual]
        var chorePoints : Int! = choreIDtoPointsDictionary[choreID]
        var choreDescription : String! = choreIDtoDescriptionDictionary[choreID]
        println(choreIDtoDoneOrNotDictionary)
        var choreDone : Bool! = choreIDtoDoneOrNotDictionary[choreID]
        cell.textLabel!.text! = choreDescription
        cell.detailTextLabel!.text! = String("Points : " + String(chorePoints))
        
        //temporary solution for too long titles
        var title : String! = cell.textLabel!.text!
        var numChars : Int = 20
        if countElements(title) > 20 {
            cell.textLabel!.text! = (title as NSString).substringToIndex(numChars) + String("...")
        }
        
        //if checkbox image is clicked
        cell.imageView!.userInteractionEnabled = true
        cell.imageView!.tag = indexPath.row
        var tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TappedCheckbox:")
        tapped.numberOfTapsRequired = 1
        cell.imageView!.addGestureRecognizer(tapped)
        
        //if cell.accessoryType == UITableViewCellAccessoryType.None {
        //    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        //} else {
        //    cell.accessoryType = UITableViewCellAccessoryType.None
        //}
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //
        return cell
    }
    
    //should change checkbox image and also add points
    func changeCheckbox(cell : UITableViewCell) {
        var unchecked_checkbox_image : UIImage! = UIImage(named: "unchecked_checkbox")
        var checked_checkbox_image : UIImage! = UIImage(named: "checked_checkbox")
        if cell.imageView!.image == checked_checkbox_image {
            println("Box is currently checked. Let's uncheck it.")
            //cell.imageView!.image = unchecked_checkbox_image
            cell.imageView!.image = UIImage(named: "unchecked_checkbox")
        } else {
            println("Box is currently unchecked. Let's check it.")
            cell.imageView!.image = checked_checkbox_image
        }
    }
//    
//    protocol tableViewDelegate {
//        func tableView(
//    }
    
    //checks which checkbox was clicked
    func TappedCheckbox(sender:UITapGestureRecognizer) {
//        var imageView : UIImageView! = sender.view! as UIImageView
//        imageView.image = UIImage(named: "unchecked_checkbox")
        
        var position : CGPoint = sender.locationInView(self.tableView)
//        var indexPath2 : NSIndexPath = tableView.indexPathForRowAtPoint(position)!
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(position)!
////        //println("Indexpath is on next line")
////        //println(indexPath)
//        var cell = tableView(tableView, cellForRowAtIndexPath: indexPath2)
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        //cell.textLabel!.text! = "change it"
        changeCheckbox(cell)
        
        //println(sender.view!.tag) //gets us row number
    }
    
    
    //gives table sections titles = person's name and points
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return person.name;
        //return "Person's name - 66 Total Pointslklk;lkklkkiooiioiioioiiioioioio"
        //return sectionTitles[indexPath.row]
        return sectionTitles[section]
        
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
