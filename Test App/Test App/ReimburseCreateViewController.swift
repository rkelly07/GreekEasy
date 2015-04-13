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
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageFile = PFFile()
    
    var newMedia: Bool?
    
    let maxNameLength: Int = 32
    let maxAmountLength: Int = 10
    let maxDescriptionLength: Int = 128
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        descriptionField.delegate = self
        amountField.delegate = self
    
        self.activityIndicator.hidden = true
    }
    
    @IBAction func takePhotoButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            newMedia = true
        }
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

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]){
    
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            photoView.image = image
            self.imageData = UIImageJPEGRepresentation(image, 0.0)
            self.imageFile = PFFile(data: self.imageData)
            self.imageFile.saveInBackground()
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            } //else if mediaType.isEqualToString(kUTTypeMovie as NSString){
                
                
            //}
        }
    }
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
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
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        let alertController = UIAlertController(title: "GreekEasy", message:
            "Reimbursement saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        // Check if text fields are nonempty or image is empty
        if (self.nameField.text.isEmpty) || (self.descriptionField.text.isEmpty) || (self.amountField.text.isEmpty) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            
            alertController.message = "Please fill out all fields"
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if (self.imageFile.getData() == nil) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            
            alertController.message = "Please take a photo or upload a photo"
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Create new reimbursement
            var newReimbursement = PFObject(className: "Reimburse")
            
            newReimbursement["name"] = self.nameField.text
            newReimbursement["description"] = self.descriptionField.text
            newReimbursement["amount"] = (self.amountField.text! as NSString).doubleValue
            newReimbursement["createdBy"] = PFUser.currentUser()!.objectForKey("username")
            newReimbursement["houseID"] = PFUser.currentUser()!.objectForKey("houseID")
            newReimbursement["photo"] = self.imageFile
            
            newReimbursement.saveEventually {
                (success: Bool, error: NSError?) -> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                
                if (success){
                    // Reimbursement Saved, clear fields
                    self.nameField.text = ""
                    self.descriptionField.text = ""
                    self.amountField.text = ""
                    self.photoView.image = nil
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // Problem; check error.description
                    NSLog(error!.description)
                    alertController.message = "Error occurred; please check network connection"
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch (textField) {
        case self.nameField:
            return (count(textField.text) <= maxNameLength)
        case self.amountField:
            return (count(textField.text) <= maxAmountLength)
        case self.descriptionField:
            return (count(textField.text) <= maxDescriptionLength)
        default:
            NSLog("Internal error when checking text field length")
            return false
        }
    }
}