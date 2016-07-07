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
        dateFromRSDF = date
        performSegueWithIdentifier("dateSelected", sender: view)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! TimeSelectionViewController
        destinationVC.dateFromRSDF = dateFromRSDF
    }
}


