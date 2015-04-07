//
//  ReimburseSingleViewController.swift
//  Test App
//
//  Created by Ryan Kelly on 4/4/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import Foundation

class ReimburseSingleViewController: UIViewController{
    @IBOutlet weak var currentUser: UILabel!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentReceipt: UIImageView!
    
    var incoming:PFObject?
    var formatter:NSDateFormatter?
    let formatString = "EEE. MMM d, yyy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter?.dateFormat = formatString
        self.formatter?.locale = NSLocale(localeIdentifier: "en_us_POSIX")
        
        currentUser.text = self.incoming!["createdBy"] as? String
        currentName.text = self.incoming!["name"] as? String
        currentDescription.text = self.incoming!["description"] as? String
        currentAmount.text = self.incoming!["amount"] as? String
        currentDate.text = self.formatter!.stringFromDate(self.incoming!["createdAt"] as NSDate)
        currentReceipt.image = self.incoming!["photo"] as? UIImage
        
    }
}