//
//  ToDoDetailViewController.swift
//  Test App
//
//  Created by Tyler Finkelstein on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var pointsPickerView: UIPickerView!
    @IBOutlet var peoplePickerView: UIPickerView!
    let fakePeopleArray : [String] = ["jack","jill","joe","bob","hank"]
    let pointsArray : [Int] = [1,2,3]
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsPickerView.dataSource = self
        pointsPickerView.delegate = self
        peoplePickerView.dataSource = self
        peoplePickerView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if (pickerView.tag == 11) {
            return pointsArray.count
        } else if (pickerView.tag == 12) {
            return fakePeopleArray.count
        } else {
            println("pickerView not found")
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pointsArray.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(pointsArray[row])
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
