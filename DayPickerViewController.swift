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
    
    override func viewWillAppear(animated: Bool) {
        setViewDefaults()
        createDatePickerView()
    }
    
    func setViewDefaults() {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 18)!]
            , forState: UIControlState.Normal)
    }
    
    func createDatePickerView() {
        let datePickerView = RSDFDatePickerView(frame: self.view.bounds)
        datePickerView.delegate = self
        datePickerView.dataSource = self
        self.view.addSubview(datePickerView)
    }
    
    func checkForCalendarAccess() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            // If you already have access to the Calendar
            print()
        case .Denied:
            // If you were not given access to the Calendar
            print()
        case .NotDetermined:
            // If it hasn't been asked to the user yet
            
            // Request permisson to the calendar
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                {(granted: Bool, error: NSError?) -> Void in
                    if granted {
                        
                    } else {
                        // If you were not given access to the Calendar by the user
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


