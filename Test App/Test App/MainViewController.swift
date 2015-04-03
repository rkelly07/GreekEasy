//
//  MainViewController.swift
//  Test App
//
//  Created by Andrew Titus on 3/11/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var allUsers : [PFUser] = []
    var allChores : [PFObject] = []
    var allEvents : [PFObject] = []
    var allReimbursements : [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO temporary dummy login
        PFUser.logInWithUsernameInBackground("tylerf", password:"greek") {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                println(PFUser.currentUser())
            } else {
                println("error")
            }
        }
        
        /*
        //get all users and add to allUsers array
        var usersQuery = PFQuery(className: "_User")
        usersQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        usersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allUsers.append(object as PFUser)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var choresQuery = PFQuery(className: "Chores")
        choresQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        choresQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allChores.append(object as PFObject)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var eventsQuery = PFQuery(className: "_User")
        eventsQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        eventsQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allEvents.append(object as PFObject)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        
        var reimbursementsQuery = PFQuery(className: "_User")
        reimbursementsQuery.whereKey("houseID", equalTo:PFUser.currentUser().objectForKey("houseID"))
        reimbursementsQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    self.allReimbursements.append(object as PFObject)
                    println(object)
                }
            } else {
                NSLog(error.description)
            }
        }
        */
        
        self.revealViewController().revealToggle(nil)

        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
