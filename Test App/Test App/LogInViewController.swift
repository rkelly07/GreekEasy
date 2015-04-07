//
//  LogInViewController.swift
//  Test App
//
//  Created by Andrew Titus on 4/7/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPWButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        activityIndicator.hidden = true
    }
    
    @IBAction func logIn() {
        if !(usernameField.text.isEmpty) || !(passwordField.text.isEmpty) {
            // Start login
            activityIndicator.startAnimating()
            activityIndicator.hidden = false
            var success = PFUser.logInWithUsername(usernameField.text!, password: passwordField.text!)
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            
            if success == nil {
                let alertController = UIAlertController(title: "GreekEasy", message:
                    "Invalid login credentials", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                var eventsStoryboard = UIStoryboard(name: "Events", bundle: nil)
                var eventsVC = eventsStoryboard.instantiateViewControllerWithIdentifier("events") as UIViewController
                presentViewController(eventsVC, animated: false, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Allows text field to be exited after entering text
        textField.resignFirstResponder()
        return true
    }
}