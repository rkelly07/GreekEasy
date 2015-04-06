//
//  EventDetailController.swift
//  Test App
//
//  Created by Andrew Titus on 4/3/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class EventDetailController: UIViewController {
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentCategory: UILabel!
    @IBOutlet weak var currentDescription: UILabel!
    
    var incoming:PFObject?
    var formatter:NSDateFormatter?
    let formatString = "EEE, MMM d, yyyy 'at' h:mm a zzz"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.formatter?.dateFormat = formatString
        self.formatter?.locale = NSLocale(localeIdentifier: "en_us_POSIX")
        
        currentName.text = self.incoming!["name"] as? String
        currentDate.text = self.formatter!.stringFromDate(self.incoming!["date"] as NSDate)
        currentLocation.text = self.incoming!["location"] as? String
        currentCategory.text = self.incoming!["category"] as? String
        currentDescription.text = self.incoming!["description"] as? String
    }
}
