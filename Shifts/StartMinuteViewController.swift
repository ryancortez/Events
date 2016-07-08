//
//  StartMinuteViewController.swift
//  Shifts
//
//  Created by Ryan Cortez on 7/7/16.
//  Copyright © 2016 Full Screen Ahead. All rights reserved.
//

import Foundation

class StartMinuteViewController : TimeSelectionViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        blinkTextInLabel(startTimeLabel, withRange: NSMakeRange(2, 2))
    }

}