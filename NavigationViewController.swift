//
//  NavigationViewController.swift
//  Shifts
//
//  Created by Ryan on 11/20/14.
//  Copyright (c) 2014 Full Screen Ahead. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationBar.tintColor = UIColor(red: 0.31, green: 0.77, blue: 1.0, alpha: 1.0)
        
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 22)!, NSForegroundColorAttributeName: UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.0)]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
