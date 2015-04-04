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
    var selectedItems : [Int] = []
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        pickerView.userInteractionEnabled = true
        var cell : UITableViewCell? = view as UITableViewCell?
        if (cell == nil) {
            //cell.init(style: UITableViewCellStyle.Default, reuseIdentifier: String?)
            cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell!.backgroundColor = UIColor.clearColor()
            cell!.tintColor = UIColor.blackColor()
            //TODO get this right - should work with x: 0
            cell!.bounds = CGRect(x: -100, y:0, width: cell!.frame.size.width, height: 44)
            cell!.tag = row
            cell!.userInteractionEnabled = true
            let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleCheckmark:")
            tapRecognizer.numberOfTapsRequired = 1
            cell!.addGestureRecognizer(tapRecognizer)
            var title : String!
            if (pickerView.tag == 11) {
                title = String(pointsArray[row])
            } else if (pickerView.tag == 12) {
                title = String(allUsersFullNames[row])
            } else {
                println("pickerView not found")
            }
            cell!.textLabel!.text = title
        }
        if !contains(selectedItems, row) {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            println("checkmark accessory")
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            println("no accessory")
        }
        return cell!
    }
    
    func toggleCheckmark(sender:UITapGestureRecognizer) {
        var row : Int = sender.view!.tag
        var indexInSelectedItems : Int? = find(selectedItems, row)
        if (indexInSelectedItems != nil) {
            selectedItems.removeAtIndex(row)
            (sender.view as UITableViewCell).accessoryType = UITableViewCellAccessoryType.None
            println("row " + String(row) + " checkmark removed")
        } else {
            selectedItems.append(row)
            (sender.view as UITableViewCell).accessoryType = UITableViewCellAccessoryType.Checkmark
            println("row " + String(row) + " checkmark added")
        }
    }

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
    
    //Don't need titleForRow b/c have viewForRow
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        var title : String!
//        if (pickerView.tag == 11) {
//            title = String(pointsArray[row])
//        } else if (pickerView.tag == 12) {
//            title = String(allUsersFullNames[row])
//        } else {
//            println("pickerView not found")
//        }
//        return title
//    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("row " + String(row) + " selected")
        if !contains(selectedItems, row) {
            selectedItems.append(row)
            //cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            var indexInSelectedItems : Int? = find(selectedItems, row)
            selectedItems.removeAtIndex(indexInSelectedItems!)
            //cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        println(selectedItems)
    }
}
