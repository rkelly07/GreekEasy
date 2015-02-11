//
//  ViewController.swift
//  HelloWorld
//
//  Created by Andrew Titus on 2/11/15.
//  Copyright (c) 2015 Andrew Titus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var label : UILabel!
    
    @IBAction func helloWorld() {
        self.label.text = "Hello 21W.789!"
    }
    
    @IBAction func goodbyeWorld() {
        self.label.text = "Goodbye 21W.789!"
    }
    
}

