//
//  LeaderboardViewController.swift
//  ToDo Section As Project
//
//  Created by Tyler Finkelstein on 3/29/15.
//  Copyright (c) 2015 Tyler Finkelstein. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Person {
        let name:String
        let totalPoints:Int!
        let currentChores:[Int];
    }
    
    var people : [Person]! = [
        Person(name: "Drew", totalPoints: 10, currentChores: [0]),
        Person(name: "Ryan", totalPoints: 300, currentChores: [1,2]),
        Person(name: "Tyler", totalPoints: 25, currentChores: [3]),
        Person(name: "Diits", totalPoints: 0, currentChores: [4,5,6])
    ]
    
    func rankPeopleByPoints(peopleList : [Person]!) -> [Person]! {
        var peopleListSorted : [Person]! = []
        //peopleListSorted = peopleList.sort({ $0.totalPoints > $1.totalPoints })
        peopleListSorted = sorted(peopleList) {$0.totalPoints > $1.totalPoints}
        return peopleListSorted
    }
    
    var peopleSortedByPoints : [Person]! = []
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        peopleSortedByPoints = rankPeopleByPoints(people)
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return person.name;
        //return "Person's name - 66 Total Pointslklk;lkklkkiooiioiioioiiioioioio"
        //return sectionTitles[indexPath.row]
        return "Points Leaderboard"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        var rank : Int! = indexPath.row
        var person : Person! = peopleSortedByPoints[rank]
        cell.textLabel!.text! = person.name
        cell.detailTextLabel!.text! = String(person.totalPoints) + String(" Points")
        //temporary solution for too long titles
        var title : String! = cell.textLabel!.text!
        var numChars : Int = 20
        if countElements(title) > 20 {
            cell.textLabel!.text! = (title as NSString).substringToIndex(numChars) + String("...")
        }
        
        return cell
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
