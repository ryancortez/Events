//
//  DayPickerViewController.swift
//  Shifts
//
//  Created by Ryan on 1/14/15.
//  Copyright (c) 2015 Full Screen Ahead. All rights reserved.
//

import UIKit
import EventKitUI

class DayPickerViewController: UIViewController, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource{

    var dateFromRSDF:NSDate = NSDate()
    let customBlueColor = UIColor(red: 0.31, green: 0.77, blue: 1.0, alpha: 1.0)
    
    override func viewWillAppear(animated: Bool) {
        checkForCalendarAccess()
    }
    
    func createDatePickerView() {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 18)!]
            , forState: UIControlState.Normal)
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.navigationItem.title = "Select a Date"
        let datePickerView = RSDFDatePickerView(frame: self.view.bounds)
        datePickerView.delegate = self
        datePickerView.dataSource = self
        datePickerView.selectDate(dateFromRSDF)
        self.view.addSubview(datePickerView)
    }
    
    func createCalendarAccessDeniedView() {
        enum AccessDeniedViewSize: CGFloat {
            case Width = 300
            case Height = 200
        }
        
        self.navigationController?.navigationBarHidden = true
        let calendarAccessDeniedView = UIView(frame: CGRectMake(0, 0, AccessDeniedViewSize.Width.rawValue, AccessDeniedViewSize.Height.rawValue))
        calendarAccessDeniedView.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        view.addSubview(calendarAccessDeniedView)
        
        let calendarAccessDeniedLabel = UILabel(frame: CGRectMake(0, 0, AccessDeniedViewSize.Width.rawValue, AccessDeniedViewSize.Height.rawValue/2))
        calendarAccessDeniedLabel.text = "This App needs access to your Calendar to save events"
        calendarAccessDeniedLabel.font = UIFont(name: "Avenir", size: 18)
        calendarAccessDeniedLabel.textAlignment = .Center
        calendarAccessDeniedLabel.numberOfLines = 0
        calendarAccessDeniedView.addSubview(calendarAccessDeniedLabel)
        
        let goToSettingsButton = UIButton(frame: CGRectMake(0, calendarAccessDeniedLabel.frame.height, AccessDeniedViewSize.Width.rawValue, AccessDeniedViewSize.Height.rawValue/2))
        goToSettingsButton.backgroundColor = customBlueColor
        goToSettingsButton.setTitle("Go to Settings", forState: .Normal)
        goToSettingsButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)
        goToSettingsButton.layer.cornerRadius = 10
        goToSettingsButton.addTarget(self, action: #selector(goToSettingsButtonPressed), forControlEvents: .TouchUpInside)
        calendarAccessDeniedView.addSubview(goToSettingsButton)
        
    }
    
    func checkForCalendarAccess() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            // If you already have access to the Calendar
            createDatePickerView()
        case .Denied:
            // If you were not given access to the Calendar
            createCalendarAccessDeniedView()
        case .NotDetermined:
            // If it hasn't been asked to the user yet
            
            // Request permisson to the calendar
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                {(granted: Bool, error: NSError?) -> Void in
                    if granted {
                        self.createDatePickerView()
                    } else {
                        // If you were not given access to the Calendar by the user
                        self.createCalendarAccessDeniedView()
                    }
            })
        default:
            print("Default Case")
        }
    }
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        dateFromRSDF = date
        performSegueWithIdentifier("dateSelected", sender: view)

    }
    
    func goToSettingsButtonPressed(sender: UIButton!) {
        
        let url:NSURL! = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! TimeSelectionViewController
        destinationVC.dateFromRSDF = dateFromRSDF
    }
}


