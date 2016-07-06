//
//  DayPickerViewController.swift
//  Shifts
//
//  Created by Ryan on 1/14/15.
//  Copyright (c) 2015 Full Screen Ahead. All rights reserved.
//

import UIKit

class DayPickerViewController: UIViewController, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource{

    var dateFromRSDF:NSDate = NSDate()
    
    override func viewWillAppear(animated: Bool) {
         self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 18)!]
            , forState: UIControlState.Normal)
        
            let datePickerView = RSDFDatePickerView(frame: self.view.bounds)
        
                datePickerView.delegate = self
                datePickerView.dataSource = self
                self.view.addSubview(datePickerView)
        
        
            }
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        
        // Break up the date selected by the DayPicker into a NSNumber that is store in shiftInfo
        // let calendar:NSCalendar = NSCalendar()
        
        dateFromRSDF = date
        NSLog("Here's the date being pulled from RSDFDatePicker: %@", date.description)
        
        // Here's a string verison of the date pulled from the RSDF calendar
        let stringFromRSDFDate:String = NSDateFormatter.localizedStringFromDate ( date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle )
        NSLog("Here's the date being pulled from RSDFDatePicker as a string: %@", stringFromRSDFDate)        
        
        // Move to the next view after the DayPicker
        performSegueWithIdentifier("dateSelected", sender: view)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let destinationVC = segue.destinationViewController as! MainViewController
 
        destinationVC.dateFromRSDF = dateFromRSDF
        NSLog("Here's what dateFromRSDF is equal to in prepareForSegue from DayPickerViewController: %@", dateFromRSDF)
        
        
    }

    }


