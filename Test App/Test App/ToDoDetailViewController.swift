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
    var selectedPeople : [Int] = []
    var selectedPoints : Int = 5 //default = 5 points
//    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
//        var cell : UITableViewCell? = view as UITableViewCell?
//        var title : String!
//        //pickerView.bounds.size.width = 400
//        if (pickerView.tag == 12) {
//            pickerView.userInteractionEnabled = true
//            if (cell == nil) {
//                //cell.init(style: UITableViewCellStyle.Default, reuseIdentifier: String?)
//                cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//                cell?.selectionStyle = UITableViewCellSelectionStyle.Blue
//                cell!.backgroundColor = UIColor.clearColor()
//                cell!.tintColor = UIColor.blackColor()
//                //TODO get this right - should work with x: 0
//                cell!.bounds = CGRect(x: -100, y:0, width: cell!.frame.size.width, height: 44)
//                cell!.tag = row
//                cell!.userInteractionEnabled = true
//                let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleCheckmark:")
//                tapRecognizer.numberOfTapsRequired = 1
//                cell!.addGestureRecognizer(tapRecognizer)
//                title = String(allUsersFullNames[row])
//                cell!.textLabel!.text = title
//            }
//            if !contains(selectedPeople, row) {
//                //var img:UIImage = UIImage(named: "checked_checkbox")!
//                //var imgView:UIImageView = UIImageView(image: img)
//                //cell!.accessoryView = imgView as UIView
//                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
//                println("checkmark accessory")
//            } else {
//                cell!.accessoryType = UITableViewCellAccessoryType.None
//                println("no accessory")
//            }
//            //self.peoplePickerView.reloadComponent(row)
//        } else if (pickerView.tag == 11) {
//            if (cell == nil) {
//                //cell.init(style: UITableViewCellStyle.Default, reuseIdentifier: String?)
//                cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
//                cell!.backgroundColor = UIColor.clearColor()
//                cell!.tintColor = UIColor.blackColor()
//                //TODO get this right - should work with x: 0
//                cell!.bounds = CGRect(x: -100, y:0, width: cell!.frame.size.width, height: 44)
//                cell!.tag = row
//                cell!.userInteractionEnabled = true
//                title = String(pointsArray[row])
//                cell!.textLabel!.text = title
//            }
//        } else {
//            println("Pickkerview not found")
//        }
//        return cell!
//    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerCustomView : UIView
        var pickerViewLabel : UILabel
        var pickerImageView : UIImageView
        pickerCustomView = UIView(frame: CGRectMake(0, 0, pickerView.frame.size.width - 10, pickerView.frame.size.height))
        pickerImageView = UIImageView(frame: CGRectMake(0, 0, 35, 35))
        pickerViewLabel = UILabel(frame: CGRectMake(37, -5, pickerView.rowSizeForComponent(component).width - 10, pickerView.rowSizeForComponent(component).height))
        pickerView.addSubview(pickerImageView)
        pickerView.addSubview(pickerViewLabel)
        pickerImageView.image = UIImage(named: "checked_checkbox")
        pickerViewLabel.backgroundColor = UIColor.clearColor()
        pickerViewLabel.text = String(pointsArray[row])
        return pickerCustomView
    }
    
//    - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//    {
//    UIView *pickerCustomView = (id)view;
//    UILabel *pickerViewLabel;
//    UIImageView *pickerImageView;
//    
//    if (!pickerCustomView) {
//    pickerCustomView= [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
//    [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
//    pickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)];
//    pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(37.0f, -5.0f,
//    [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
//    // the values for x and y are specific for my example
//    [pickerCustomView addSubview:pickerImageView];
//    [pickerCustomView addSubview:pickerViewLabel];
//    }
//    
//    pickerImageView.image = [self selectTherapyImageFor:therapyTypes[row]];
//    pickerViewLabel.backgroundColor = [UIColor clearColor];
//    pickerViewLabel.text = therapyTypes[row]; // where therapyTypes[row] is a specific example from my code
//    pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
//    
//    return pickerCustomView;
//    }
    
    func toggleCheckmark(sender:UITapGestureRecognizer) {
        var row : Int = sender.view!.tag
        var indexInselectedPeople : Int? = find(selectedPeople, row)
        if (indexInselectedPeople != nil) {
            selectedPeople.removeAtIndex(row)
            (sender.view as UITableViewCell).accessoryType = UITableViewCellAccessoryType.None
            println("row " + String(row) + " checkmark removed")
        } else {
            selectedPeople.append(row)
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
        if (pickerView.tag == 12) {
            println("Person at row " + String(row) + " selected")
            if !contains(selectedPeople, row) {
                selectedPeople.append(row)
                //cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                var indexInselectedPeople : Int? = find(selectedPeople, row)
                selectedPeople.removeAtIndex(indexInselectedPeople!)
                //cell!.accessoryType = UITableViewCellAccessoryType.None
            }
            println(selectedPeople)
        } else if (pickerView.tag == 11) {
            selectedPoints = row + 1
            println("Chore is worth " + String(selectedPoints) + " points")
        }
    }
}
