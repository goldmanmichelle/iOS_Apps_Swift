//
//  ViewController.swift
//  UserData
//  Updated 12/19/15 Week 4 File
//  Created by Michelle Goldman on 12/1/15.
//  Last updated 12/5/15
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signupActive = true
    var validated = true
    var currentString = NSString()
    var maxLength = Int()
    var minLength = Int()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var registeredLabel: UILabel!
    @IBOutlet var usernamePrompt: UILabel!
    @IBOutlet var passwordPrompt: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
                
        username.delegate = self
        username.tag = 1
        password.delegate = self
        password.tag = 2
        
        hideTextfieldPrompts()

    }
    
    override func viewDidAppear(animated: Bool) {
        //Check to see if current user is still logged in. If so, go directly to My Courses list.
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("goToLogin", sender: self)
        } else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: SIGN UP
    @IBAction func signup(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            //If not, present alert
            displayAlert("Form Error", message: "Please enter a username and password!")
        } else if count(username.text.utf16) < 4 || count(username.text.utf16) > 10 {
            self.displayAlert("Form Error", message: "Username must be between 4 and 10 characters.")
            usernamePrompt.hidden = false
            validated = false
        } else if count(password.text.utf16) < 8 || count(username.text.utf16) > 8 {
            self.displayAlert("Form Error", message: "Password must be 8 numbers.")
            passwordPrompt.hidden = false
            validated = false
        } else {
            hideTextfieldPrompts()
            //If user is signing up for first time, change to sign up mode
            var errorMsg = "Please try again later."
            if Reachability.isConnected() == true {
                if signupActive == true  {
                    var user = PFUser()
                    user.username = username.text
                    user.password = password.text
                    
                    user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            //Sign up user - successful
                            self.switchMode()
                            self.displayAlert("Sign Up Successful", message: "")
                            self.performSegueWithIdentifier("login", sender: self)
                        } else {
                            //Alert user there was error in sign up
                            if let errorString = error!.userInfo?["error"] as? String {
                                errorMsg = errorString
                            }
                            self.displayAlert("Sign Up Failed", message: errorMsg)
                        }
                    })
                    
                } else {
                    //Change to login mode if user has already signed up
                    PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                        if user != nil  {
                            //Clear editText fields
                            self.resetFields()
                            // Log user in
                            self.performSegueWithIdentifier("goToLogin", sender: self)
                        } else {
                            //Alert user there was an error logging in
                            if let errorString = error!.userInfo?["error"] as? String {
                                errorMsg = errorString
                            }
                            self.displayAlert("Login Failed", message: errorMsg)
                        }
                    })
                }
            } else if Reachability.isConnected() == false {
                self.displayAlert("Network Error", message: "Please connect to WIFI and try again.")
                print("no network")
            }
        }
    }
    
    //MARK: LOGIN
    @IBAction func login(sender: AnyObject) {
        //Change state of Sign Up and Login buttons
        if signupActive == true {
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            registeredLabel.text = "Not registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
        } else {
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredLabel.text = "Already registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
        }
    }
 
    //MARK: VALIDATE TEXTFIELDS
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        switch textField.tag {
        case 1:
            currentString = username.text
            let inverseAlphaSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
            let components = string.componentsSeparatedByCharactersInSet(inverseAlphaSet)
            let filtered = join("", components)
            return string == filtered
        case 2:
            currentString = password.text
            let inverseNumericSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let components = string.componentsSeparatedByCharactersInSet(inverseNumericSet)
            let filtered = join("", components)
            return string == filtered
        default:
            println("No fields detected.")
        }
        return true
    }


    //MARK: SWITCH SIGN UP/ LOGIN MODE
    func switchMode(){
        signupButton.setTitle("Log In", forState: UIControlState.Normal)
        registeredLabel.text = "Not registered?"
        loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
        signupActive = false
        hideTextfieldPrompts()
    }
    
    //MARK DISPLAY ALERT
    func displayAlert(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: RESET FIELDS
    func resetFields() {
        username.text = ""
        password.text = ""
    }

    //MARK: HIDE TEXTFIELD PROMPT MESSAGES
    func hideTextfieldPrompts() {
        usernamePrompt.hidden = true
        passwordPrompt.hidden = true
    }
}

