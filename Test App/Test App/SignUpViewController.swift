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
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Allows text field to be exited after entering text
        textField.resignFirstResponder()
        return true
    }
}
