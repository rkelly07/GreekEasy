//
//  SecondStoryBoardViewController.swift
//  ToDo Section As Project
//
//  Created by Tyler Finkelstein on 3/20/15.
//  Copyright (c) 2015 Tyler Finkelstein. All rights reserved.
//

import UIKit

class SecondStoryBoardViewController: UIViewController {

    @IBOutlet var randomLabel: UILabel!
    @IBOutlet var changeTextColor: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        randomLabel.textColor = UIColor.purpleColor()
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
