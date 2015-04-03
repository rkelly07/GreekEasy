//
//  ToDoDetailViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var choreObject : PFObject!
    var choreID : Int!
    var choreTitle : String!
    var chorePoints : Int!
    var allUsers : [PFUser]! = []
    var allUsersFullNames : [String]! = []
    var peopleOnChore : [PFUser] = []
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var pointsPickerView: UIPickerView!
    @IBOutlet var peoplePickerView: UIPickerView!
    //let maxPoints : Int = 100
    let pointsArray : [Int] = Array(1...100)
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsPickerView.dataSource = self
        pointsPickerView.delegate = self
        peoplePickerView.dataSource = self
        peoplePickerView.delegate = self
        pointsPickerView.selectRow(chorePoints - 1, inComponent: 0, animated: true)
        populateUserFullNamesArray()
        titleTextField.text = choreTitle
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
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int!
        if (pickerView.tag == 11) {
            count = pointsArray.count
        } else if (pickerView.tag == 12) {
            count = allUsersFullNames.count
        } else {
            println("pickerView not found")
        }
        return count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var title : String!
        if (pickerView.tag == 11) {
            title = String(pointsArray[row])
        } else if (pickerView.tag == 12) {
            title = String(allUsersFullNames[row])
        } else {
            println("pickerView not found")
        }
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("row " + String(row) + " selected")
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
