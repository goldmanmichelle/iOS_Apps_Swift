//
//  AddCourse.swift
//  UserData
//  Updated 12/19/15 Week 4 File
//  Created by Michelle Goldman on 12/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import Foundation
import Parse

class AddCourse: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var courseName: UITextField!
    @IBOutlet var timesTaken: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var coursenamePrompt: UILabel!
    @IBOutlet var timestakenPrompt: UILabel!
    
    
    var validated = true
    var currentString = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseName.delegate = self
        courseName.tag = 1
        timesTaken.delegate = self
        timesTaken.tag = 2
        hideTextfieldPrompts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: SAVE COURSE
    @IBAction func saveCourse(sender: AnyObject) {
     
        //Check to make sure fields aren't empty
        if courseName.text == "" && timesTaken.text == "" {
            
            //Alert user there was error in saving course
            var alert = UIAlertController(title: "Form Error", message: "Please complete both fields!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            })))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if count(courseName.text.utf16) < 3 || count(courseName.text.utf16) > 24 {
            self.displayTextfieldAlert("Form Error", message: "Course name must be between 3 and 24 characters.")
            coursenamePrompt.hidden = false
            validated = false
            
        } else if count(timesTaken.text.utf16) < 1 || count(timesTaken.text.utf16) > 2 {
            self.displayTextfieldAlert("Form Error", message: "Number of times must be 2 digits or less.")
            timestakenPrompt.hidden = false
            validated = false
            
        } else {
            
            //Upload course to Parse
            if Reachability.isConnected() == true {
                //Create PFObject
                var currentUser = PFUser.currentUser
                //Convert timesTaken string to integer
                let number : Int? = timesTaken.text.toInt()
                //Create parse object to be saved
                var newCourse = PFObject(className: "Courses")
                newCourse["userName"] = PFUser.currentUser()!.username!
                newCourse["courseName"] = courseName.text
                newCourse["timesTaken"] = number!
                newCourse.pinInBackground()
                newCourse.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if(success) {
                        //Alert user course was saved
                        self.displayGeneralAlert("Course Saved!", message: "")
                        self.hideTextfieldPrompts()
                        println("worked!")
                    } else {
                        //Alert user there was an error saving course
                        self.displayGeneralAlert("Error saving course", message: "Please try again!")
                        println("broken!")
                    }
                })
            } else if Reachability.isConnected() == false {
                //Create PFObject
                var currentUser = PFUser.currentUser
                //Convert timesTaken string to integer
                let number : Int? = timesTaken.text.toInt()
                //Create parse object to be saved
                var newCourse = PFObject(className: "Courses")
                newCourse["userName"] = PFUser.currentUser()!.username!
                newCourse["courseName"] = courseName.text
                newCourse["timesTaken"] = number!
                newCourse.pinInBackground()
                newCourse.saveEventually()
                //Alert user course was saved
                self.displayGeneralAlert("Network Error!", message: "Course will be saved once connected to network.")
                self.hideTextfieldPrompts()
                println("save at some point!")
            }
        }
    }
  
    //MARK: VALIDATE TEXTFIELDS
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            currentString = courseName.text
            let inverseAlphaSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
            let components = string.componentsSeparatedByCharactersInSet(inverseAlphaSet)
            let filtered = join("", components)
            return string == filtered
        case 2:
            currentString = timesTaken.text
            let inverseNumericSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let components = string.componentsSeparatedByCharactersInSet(inverseNumericSet)
            let filtered = join("", components)
            return string == filtered
        default:
            println("No fields detected.")
        }
        return true
    }
    
    //MARK: HIDE TEXTFIELD PROMPT MESSAGES
    func hideTextfieldPrompts() {
        coursenamePrompt.hidden = true
        timestakenPrompt.hidden = true
    }
    
    //MARK DISPLAY TEXTFIELD ALERT
    func displayTextfieldAlert(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
     
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //MARK DISPLAY GENERAL ALERTS
    func displayGeneralAlert(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(false, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
