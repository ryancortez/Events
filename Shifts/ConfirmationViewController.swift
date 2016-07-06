
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startOver () {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.31, green: 0.77, blue: 1.0, alpha: 1.0)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) { 
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ConfirmationViewController.startOver), userInfo: nil, repeats: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
