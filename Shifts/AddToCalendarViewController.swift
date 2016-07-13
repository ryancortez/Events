//
//  AddToCalendarViewController.swift
//  Events
//
//  Created by Ryan Cortez on 7/9/16.
//  Copyright © 2016 Full Screen Ahead. All rights reserved.
//

import Foundation
import UIKit

class AddToCalendarViewController: TimeSelectionViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleTextView()
    }
    
    func setupTitleTextView() {
        if (titleOutlet != nil) {
            if (titleOutlet.text == "Add title here"){
                titleOutlet.textColor = customGraycolor
            }
        }
    }
}