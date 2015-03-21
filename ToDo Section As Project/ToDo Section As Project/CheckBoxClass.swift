//
//  CheckBoxClass.swift
//  ToDo Section As Project
//
//  Created by Tyler Finkelstein on 3/21/15.
//  Copyright (c) 2015 Tyler Finkelstein. All rights reserved.
//

import UIKit

class CheckBoxClass: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //images
    let checkedImage = UIImage(named: "checked_checkbox")
    let uncheckedImage = UIImage(named: "unchecked_checkbox")
    
    //boolean property - checked or unchecked
    var isChecked:Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "checkButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    //flip value of checked or not
    func checkButtonClicked(sender:UIButton) {
        if (sender == self) {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
