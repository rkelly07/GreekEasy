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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentName.text = incoming!["name"] as? String
        currentDate.text = incoming!["date"].descriptionWithLocale(NSLocale.currentLocale())
        currentLocation.text = incoming!["location"] as? String
        currentCategory.text = incoming!["category"] as? String
        currentDescription.text = incoming!["description"] as? String
    }
}
