//
//  ToDoViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 3/20/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource {
    
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
    ]
    
    var people : [Person]! = [
        Person(name: "Drew", totalPoints: 10, currentChores: [0]),
        Person(name: "Ryan", totalPoints: 300, currentChores: [1,2]),
        Person(name: "Tyler", totalPoints: 25, currentChores: [3])
    ]
    
    // this doesn't work?
//    var numberOfPeople : Int! = people!.count
    
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
    
    var person: Person!
    var index: Int!
    
    //below for loop doesn't work?
//    for index in 0...<numberOfPeople! {
//        sections[index] = people[index].name
//    }
    
    //Below three functions are for UITableViewDataSource
    
    //how many sections in the chores table = number of people
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return people.count
    }
    
    //how many rows in each section = number of chores for a given person
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count //need to make this equal to the length of person's chore list
    }
    
    //contents of each cell = description of chores for a given person
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = people[indexPath.row].currentChores[0].description //need to fix this
        return cell
    }
    
    //gives table sections titles = person's name and points
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Person's name"
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
