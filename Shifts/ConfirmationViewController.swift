
//
//  ConfirmationViewController.swift
//  Shifts
//
//  Created by Ryan on 2/25/15.
//  Copyright (c) 2015 Full Screen Ahead. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    var shiftInfo:Event = Event()
    var dateFromRSDF: NSDate?
    
    func startOver () {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.31, green: 0.77, blue: 1.0, alpha: 1.0)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ConfirmationViewController.startOver), userInfo: nil, repeats: false)
    }
 }
