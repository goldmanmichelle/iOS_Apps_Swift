//
//  MyCourses.swift
//  UserData
//  Updated 12/19/15 Week 4 File
//  Created by Michelle Goldman on 12/1/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import Foundation
import Parse


class MyCourse: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    

    var parseRefreshControl = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    var usernames = [""]
    var courseName = [""]
    var timesTaken = [""]
    var courseArray : NSMutableArray = []
    var timer = NSTimer()
    
    @IBOutlet var currentUsername: UILabel!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var addCourseButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: TIMER FOR PARSE SERVER POLLING ASYNC TASK
        timer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: "pollParse", userInfo: nil, repeats: true)
        
        //MARK: REFRESH CONTROL
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        self.parseRefreshControl.backgroundColor = UIColor.clearColor()
        self.parseRefreshControl.tintColor = UIColor.blueColor()
        self.parseRefreshControl.attributedTitle = NSAttributedString(string:"Pull to refresh courses")
        self.parseRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(parseRefreshControl)

        //Handle data based on network connectivity
        if Reachability.isConnected() == true {
            refresh()
            loadData()
        } else if Reachability.isConnected() == false {
            loadLocalCourses()
        }
        
        
        //Update user's name at top of course list
        currentUsername.text = PFUser.currentUser()!.username
        }
    
    
        //MARK: LOAD INITIAL PARSE DATA
        func loadData() {
            if Reachability.isConnected() == true {
                var query = PFQuery(className: "Courses")
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    query.orderByAscending("createdAt")
                    
                    if error == nil {
                        // The find succeeded.
                        print("***TEST:SUCCESSFULLY RETRIEVED \(objects!.count) COURSES FROM PARSE refresh().")
                        
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                
                                self.courseArray.addObject(object)
                                
                                //Update refrech control title
                                let now = NSDate()
                                let updatedString = "Courses updated at " + self.dateFormatter.stringFromDate(now)
                                self.parseRefreshControl.attributedTitle = NSAttributedString(string: updatedString)
                                
                                //Stop refresh control from appearing
                                if self.parseRefreshControl.refreshing{
                                    self.parseRefreshControl.endRefreshing()
                                }
                                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        }
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                })
 
            } else if Reachability.isConnected() == false {
                //Load courses pinned in background
                loadLocalCourses()
            }
    }
    
    //MARK: LOAD COURSES FROM PARSE LOCAL DATA STORE ON DEVICE 
    func loadLocalCourses() {
        if Reachability.isConnected() == false {
            //Add dispatch_async with timer to run parse polling
            dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                var query = PFQuery(className: "Courses")
                query.fromLocalDatastore()
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    query.orderByAscending("createdAt")
                    
                    self.courseArray.removeAllObjects()

                    if error == nil {
                        // The find succeeded.
                        print("***TEST:PULLING COURSES FROM LOCAL DATA STORE.")
                        
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                
                                self.courseArray.addObject(object)
                                
                                //Update course list
                                self.tableView.reloadData()
                            }
                        }
                    }
                })
                
            }
        }
        
    }

    //MARK: POLL PARSE TO UPDATE DATA IN BACKGROUND
    func pollParse() {
        //Add dispatch_async with timer to run parse polling
        dispatch_async(dispatch_get_main_queue()) {[unowned self] in
            var query = PFQuery(className: "Courses")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                query.orderByAscending("createdAt")
                
                self.courseArray.removeAllObjects()
                
                if error == nil {
                    // The find succeeded.
                    print("***TEST:POLLING PARSE USING DISPATCH_ASYNC.")
                    
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            self.courseArray.addObject(object)
                            
                            //Update course list
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            })
        }
    }

    
    //MARK: REFRESH COURSE LISTVIEW USING PULL TO REFRESH CONTROLLER
    func refresh() {
        if Reachability.isConnected() == true {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                //Get updates from Parse
                self.pollParse()
                //Reload TableView
                self.tableView.reloadData()
                self.parseRefreshControl.endRefreshing()
                println("Updating courses...")
            }
        } else if Reachability.isConnected() == false {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.loadLocalCourses()
                //Reload TableView
                self.tableView.reloadData()
                self.parseRefreshControl.endRefreshing()
                println("Courses will update once connected to network...")
            }
        }
       
    }
    
 
    //MARK: TABLEVIEW SET UP
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            //Remove course from Parse
            self.courseArray[indexPath.row].deleteInBackground()
            //Remove course from tableview
            courseArray.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        //Refresh courses
        self.tableView.reloadData()
       
    }
  
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //enter code here
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! UITableViewCell
        var object: PFObject = self.courseArray.objectAtIndex(indexPath.row) as! PFObject
        cell.textLabel?.text = object["courseName"] as? String
        cell.detailTextLabel?.text = String(stringInterpolationSegment: object["timesTaken"]as! Int)

        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: ADD COURSE
    @IBAction func addCourse(sender: AnyObject) {
        self.performSegueWithIdentifier("addCourse", sender: self)
    }
    
    
    //MARK: LOG OUT
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        
        if Reachability.isConnected() == true {
            logoutButton.enabled = true
            PFUser.logOut()
            
            //Alert user of logout
            var alert = UIAlertController(title: "Logout of User Data", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction((UIAlertAction(title: "Cancel", style: .Default, handler: {(action) -> Void in
            })))
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }else if Reachability.isConnected() == false {
            logoutButton.enabled = false

        }
        

    }
}