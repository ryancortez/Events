//
//  StartHourViewController.swift
//  Shifts
//
//  Created by Ryan Cortez on 7/7/16.
//  Copyright © 2016 Full Screen Ahead. All rights reserved.
//

import Foundation

class StartHourViewController : TimeSelectionViewController {
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        blinkTextInLabel(startTimeLabel, withRange: NSMakeRange(0, 1))
        self.navigationController?.navigationBar.tintColor  = customBlueColor
    }
}