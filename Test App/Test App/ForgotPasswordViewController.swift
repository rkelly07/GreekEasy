//
//  ForgotPasswordViewController.swift
//  Test App
//
//  Created by Andrew Titus on 4/7/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        
        activityIndicator.hidden = true
    }
    
    @IBAction func sendResetEmail() {
        var email = emailField.text
        
        // Send password reset email
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        let success = PFUser.requestPasswordResetForEmail(email)
        emailField.endEditing(true)
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        
        // Display message based on whether email send succeeded
        if !(success) {
            let alertController = UIAlertController(title: "GreekEasy", message:
                "No user exists for this email", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "GreekEasy", message:
                "A reset email has been sent to \(email)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            emailField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Allows text field to be exited after entering text
        textField.resignFirstResponder()
        return true
    }
}
