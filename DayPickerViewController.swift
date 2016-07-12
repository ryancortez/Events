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
    
    let customRedColor = UIColor(red: 0.9372549019607843, green: 0.42745098039215684, blue: 0.42745098039215684, alpha: 1.0)

    var dateFromRSDF:NSDate = NSDate()
    
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
        self.view.addSubview(datePickerView)
    }
    
    func createCalendarAccessDeniedView() {
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let accessDeniedView = UIView(frame: self.view.bounds)
        accessDeniedView.backgroundColor = customRedColor
        self.view.addSubview(accessDeniedView)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! TimeSelectionViewController
        destinationVC.dateFromRSDF = dateFromRSDF
    }
}


