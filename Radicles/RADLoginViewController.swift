//
//  RADLoginViewController.swift
//  Radicles
//
//  Created by William Tachau on 9/16/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import Foundation

protocol LoginDelegate {
    func showApp()
}

class RADLoginViewController : UITableViewController, UITableViewDelegate, UITableViewDataSource {

    // to handle UI on login click
    let loginIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var doneString = "done"
    
    // what to do after successful login
    var delegate:LoginDelegate?
    
    override func viewDidLoad() {
        tableView.backgroundColor = backgroundColor
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard", name: UIKeyboardDidShowNotification, object: nil)
        
        // get rid of separator color
        tableView.separatorColor = UIColor.clearColor()
    }
    
    // Refresh city text in case new city was chosen
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // Attempt logging in through Parse
    func tryLogin() {
        PFUser.logInWithUsernameInBackground(nameField.text, password: passwordField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            
            self.loginIndicator.stopAnimating()
            self.doneString = "done"
            if (user != nil) {
                self.delegate!.showApp()
            } else {
                let errorString = error.userInfo!["error"] as NSString
                self.doneString = "done"
                self.tableView.reloadData()
                
                // Present alert
                //                let alert = UIAlertView(title: "Error", message: errorString.capitalizedString, delegate: nil, cancelButtonTitle: "Ok")
                //                alert.show()
                
                // THIS WILL NEED TO BE IN IOS 8
                //                var alert = UIAlertController(title: "Error", message: errorString.capitalizedString, preferredStyle: UIAlertControllerStyle.Alert)
                //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                //                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Attempt signing up through Parse
    func trySignup() {
        var user = PFUser()
        user.username = nameField.text
        user.password = passwordField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            
            self.loginIndicator.stopAnimating()
            self.doneString = "done"
            if (error == nil) {
                self.delegate!.showApp()
            } else {
                let errorString = error.userInfo!["error"] as NSString
                self.doneString = "done"
                self.tableView.reloadData()
                
                // Present alert
                //                let alert = UIAlertView(title: "Error", message: errorString.capitalizedString, delegate: nil, cancelButtonTitle: "Ok")
                //                alert.show()
                
                //                FOR IOS 8
                //                var alert = UIAlertController(title: "Error", message: errorString.capitalizedString, preferredStyle: UIAlertControllerStyle.Alert)
                //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                //                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    var emptyCells = 2
    var keyboardShowing = false
    var nameField = UITextField()
    var passwordField = UITextField()
    var doneText = UILabel()
    
    // toggle signup or login
    var onSignup = true
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //since uitextfields prevent this method from being called, always call hide keyboard from here
        //hideKeyboard()
        if indexPath.row == (emptyCells + 3) {
            // login
            doneString = ""
            self.tableView.reloadData()
            self.loginIndicator.startAnimating()
            self.onSignup ? self.trySignup() : self.tryLogin()
            // User toggles signup/ login
        } else if indexPath.row == emptyCells {
            onSignup = !self.onSignup
            self.tableView.reloadData()
        }
    }
    
//    func showKeyboard() {
//        if !keyboardShowing {
//            emptyCells -= 2
//            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
//        }
//        keyboardShowing = true
//        
//    }
//    
//    func hideKeyboard() {
//        if keyboardShowing {
//            emptyCells += 2
//            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
//            self.tableView.endEditing(true)
//        }
//        keyboardShowing = false
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emptyCells + 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        cell = self.setUpCell(indexPath.row - emptyCells)
        return cell!
    }
}