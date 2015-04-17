//
//  AssignmentSelectViewController.swift
//  Test App
//
//  Created by Andrew Titus on 4/16/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class AssignmentSelectViewController: UIViewController {
    @IBOutlet weak var autoAssignButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoAssignButton.titleLabel?.textAlignment = NSTextAlignment.Center
    }
    
    @IBAction func displayNotImplementedMessage() {
        let alertController = UIAlertController(title: "GreekEasy", message:
            "Automatic assignment will be implemented soon!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
