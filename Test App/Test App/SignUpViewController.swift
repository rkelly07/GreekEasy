//
//  SignUpViewController.swift
//  Test App
//
//  Created by Andrew Titus on 4/7/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var houseIDField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let keyboardSize = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        houseIDField.delegate = self
        passwordField.delegate = self
        passwordCheckField.delegate = self
        
        activityIndicator.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // Shift keyboard when textfield used
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    @IBAction func signUp() {
        if !(usernameField.text.isEmpty) || !(firstNameField.text.isEmpty) || !(lastNameField.text.isEmpty) || !(emailField.text.isEmpty) || !(houseIDField.text.isEmpty) || !(passwordField.text.isEmpty) ||  !(passwordCheckField.text.isEmpty) {
            // Check if passwords match
            if !(passwordField.text == passwordCheckField.text) {
                let alertController = UIAlertController(title: "GreekEasy", message:
                    "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Start signup
                activityIndicator.startAnimating()
                activityIndicator.hidden = false
                
                var newUser = PFUser()
                
                newUser.username = usernameField.text
                newUser.password = passwordField.text
                newUser.email = emailField.text
                newUser["firstName"] = firstNameField.text
                newUser["lastName"] = lastNameField.text
                newUser["houseID"] = houseIDField.text.toInt()
                newUser["houseManager"] = false
                newUser["treasurer"] = false
                newUser["totalPoints"] = 0
                newUser["currentChores"] = []
                
                let success = newUser.signUp()
                activityIndicator.stopAnimating()
                activityIndicator.hidden = true
                
                // Display error message or sign user in
                if !(success) {
                    let alertController = UIAlertController(title: "GreekEasy", message:
                        "Invalid login credentials. Username may be already taken or house ID was incorrectly entered", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // Sign user in
                    activityIndicator.startAnimating()
                    activityIndicator.hidden = false
                    let logInSuccess = PFUser.logInWithUsername(usernameField.text, password: passwordField.text)
                    activityIndicator.stopAnimating()
                    activityIndicator.hidden = true
                    
                    // Display error message if login failed; else go to events
                    if logInSuccess == nil {
                        let alertController = UIAlertController(title: "GreekEasy", message:
                            "Error logging in; please try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        var eventsStoryboard = UIStoryboard(name: "Events", bundle: nil)
                        var eventsVC = eventsStoryboard.instantiateViewControllerWithIdentifier("events") as UIViewController
                        presentViewController(eventsVC, animated: false, completion: nil)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "GreekEasy", message:
                "Please fill out all fields", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Allows text field to be exited after entering text
        textField.resignFirstResponder()
        return true
    }
}
