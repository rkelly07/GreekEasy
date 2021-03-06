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
    var photo:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatter?.dateFormat = formatString
        self.formatter?.locale = NSLocale(localeIdentifier: "en_us_POSIX")
        
        let photoFile = self.incoming!["photo"] as! PFFile
        photoFile.getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                self.photo = UIImage(data: imageData!)
                self.currentReceipt.image = self.photo
            }
        }
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("username", equalTo: (self.incoming!["createdBy"] as? String)!)
        let user = userQuery!.findObjects()![0] as! PFUser
        let fullName = (user.objectForKey("firstName") as! String) + " " + (user.objectForKey("lastName") as! String)
        
        currentUser.text = fullName
        currentName.text = self.incoming!["name"] as? String
        currentDescription.text = self.incoming!["description"] as? String
        currentAmount.text = String(format:"$%.2f", self.incoming!["amount"] as! Double)
        currentDate.text = self.formatter!.stringFromDate(self.incoming!.createdAt!)
        
    }
}