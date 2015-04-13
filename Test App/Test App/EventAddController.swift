//
//  EventAddController.swift
//  Test App
//
//  Created by Andrew Titus on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class EventAddController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var createButton: UIButton!
    
    let maxNameLength: Int = 32
    let maxLocationLength: Int = 32
    let maxDescriptionLength: Int = 128
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        locationField.delegate = self
        descriptionField.delegate = self
        
        // Set minimum date on time picker to now
        datePicker.minimumDate = NSDate(timeIntervalSinceNow: 0)
    }
    
    // TODO: Input validation
    @IBAction func saveEvent() {
        // Set up alert to display
        let alertController = UIAlertController(title: "GreekEasy", message:
            "Event saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        // Check if input is valid or not
        if (self.nameField.text.isEmpty) || (self.locationField.text.isEmpty) || (self.descriptionField.text.isEmpty) {
            alertController.message = "Please make sure all fields are filled out"
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Set object
            var newEvent = PFObject(className: "Event")
            newEvent["name"] = self.nameField.text
            newEvent["location"] = self.locationField.text
            newEvent["description"] = self.descriptionField.text
            newEvent["date"] = self.datePicker.date
            newEvent["createdBy"] = PFUser.currentUser()!.objectForKey("username")
            newEvent["houseID"] = PFUser.currentUser()!.objectForKey("houseID")
            
            // Save asynchronously to Parse
            newEvent.saveEventually() {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // Event has been saved; clear fields and present message
                    self.nameField.text = ""
                    self.locationField.text = ""
                    self.descriptionField.text = ""
                    self.datePicker.date = NSDate(timeIntervalSinceNow: 0)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // Problem; check error.description
                    NSLog(error!.description)
                    alertController.message = "Error in saving event; please try again"
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Allows text field to be exited after entering text
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch (textField) {
        case self.nameField:
            return (count(textField.text) <= maxNameLength)
        case self.locationField:
            return (count(textField.text) <= maxLocationLength)
        case self.descriptionField:
            return (count(textField.text) <= maxDescriptionLength)
        default:
            NSLog("Internal error when checking text field length")
            return false
        }
    }
}
