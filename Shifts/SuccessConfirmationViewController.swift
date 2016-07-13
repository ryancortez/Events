//
//  SuccessScreen.swift
//  Events
//
//  Created by Ryan Cortez on 7/13/16.
//  Copyright © 2016 Full Screen Ahead. All rights reserved.
//

import Foundation
import UIKit

class SuccessConfirmationViewController: ConfirmationViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ConfirmationViewController.startOver), userInfo: nil, repeats: false)
    }
}