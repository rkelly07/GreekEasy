//
//  ReimburseCreateViewController.swift
//  Test App
//
//  Created by Ryan Kelly on 4/4/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import Foundation
import MobileCoreServices

class ReimburseCreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var amountField: UITextField!
    let imagePicker = UIImagePickerController()
    
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        descriptionField.delegate = self
        amountField.delegate = self
    
    }
    
    @IBAction func uploadPhotoButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = false
        }
    }
    @IBAction func takePhotoButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            newMedia = true
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]){
    
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            
            photoView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo", nil)
            } //else if mediaType.isEqualToString(kUTTypeMovie as NSString){
                
                
            //}
        }
    }
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfor:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButton(sender: AnyObject) {
        var newReimbursement = PFObject(className: "Reimburse")
        
        newReimbursement["name"] = self.nameField.text?
        newReimbursement["description"] = self.descriptionField.text?
        newReimbursement["amount"] = (self.amountField.text! as NSString).doubleValue
        newReimbursement["createdBy"] = PFUser.currentUser().objectForKey("username")
        newReimbursement["houseID"] = PFUser.currentUser().objectForKey("houseID")
        newReimbursement["photo"] = self.photoView.image?
        
        let alertController = UIAlertController(title: "GreekEasy", message:
            "Reimbursement saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        newReimbursement.saveEventually(){
            (success: Bool, error: NSError!) -> Void in
            if (success){
                // Reimbursement Saved, clear fields 
                self.nameField.text = ""
                self.descriptionField.text = ""
                self.amountField.text = ""
                // Reset photo view
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Problem; check error.description
                NSLog(error.description)
                alertController.message = "Error occurred; please check network connection"
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}