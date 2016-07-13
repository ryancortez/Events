//
//  AddToCalendarViewController.swift
//  Events
//
//  Created by Ryan Cortez on 7/9/16.
//  Copyright © 2016 Full Screen Ahead. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class AddToCalendarViewController: TimeSelectionViewController, UITextFieldDelegate {

    let eventTitleKey = "Event Title"
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        titleTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveData()
        titleTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveData()
    }
    
    func saveData() {
        if (titleTextField != nil){
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths.objectAtIndex(0) as! NSString
            let path = documentsDirectory.stringByAppendingPathComponent("Settings.plist")
            
            let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
            // Saving values
            dict.setObject(titleTextField.text!, forKey: eventTitleKey)
            
            // Writing to Settings.plist
            dict.writeToFile(path, atomically: false)
            
            let resultDictionary = NSMutableDictionary(contentsOfFile: path)
            print("Saved Settings.plist file is --> \(resultDictionary?.description)")
        }
    }
    
    func loadData() {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let path = paths.URLByAppendingPathComponent("Settings.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // Check if file exists
        if(path.checkResourceIsReachableAndReturnError(nil) == true) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().URLForResource("Settings", withExtension: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfURL: bundlePath)
                print("Bundle Settings.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItemAtURL(bundlePath, toURL: path)
                } catch _ {
                }
                print("copy")
            } else {
                print("Settings.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("Settings.plist already exits at path.")
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfURL: path)
        print("Loaded Settings.plist file is --> \(resultDictionary?.description)")
        
        let myDict = NSDictionary(contentsOfURL: path)
        if let dict = myDict {
            // Loading values
            if (dict.objectForKey(eventTitleKey)! as? String != nil) {
                 titleTextField.text = dict.objectForKey(eventTitleKey)! as? String
            }
        } else {
            print("Could not create dictionary from Settings.plist. Default values will be used")
        }
    }
    
    func saveEvent(toEventStore eventStore: EKEventStore, withStartdate startDate: NSDate, andEndDate endDate: NSDate) {
        
        // Sets calendar events title to a default title if there is nothing set by the user
        let event = EKEvent(eventStore: eventStore)
        if (titleTextField.text != nil) {
            event.title = titleTextField.text! // Sets event's title
        } else {
            event.title = "Event"
        }
        
        // The calendar event is added the default calendar
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.startDate = startDate
        event.endDate = endDate
        
        // Initially sets errors to nil
        var saveError : NSError? = nil
        
        // Commits changes and allows saveEvent to change error from nil
        do {
            try eventStore.saveEvent(event, span: .ThisEvent, commit: true)
        } catch let error as NSError {
            saveError = error
        }
        
        // Following checks for errors and prints result to Debug Area
        if saveError != nil {
            print("Saving event to Calendar failed with error: \(saveError!)")
        } else {
            print("Successfully saved '\(event.title)' to '\(event.calendar.title)' calendar.")
        }
        
    }
    
    // Abstracts away the implemenation for storing events
    func saveEvent(withStartDate startDate:NSDate , andEndDate endDate:NSDate) {
        
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            saveEvent(toEventStore: eventStore, withStartdate: startDate, andEndDate: endDate)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                {(granted: Bool, error: NSError?) -> Void in
                    if granted {
                        self.saveEvent(toEventStore: eventStore, withStartdate: startDate, andEndDate: endDate)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Default Case")
        }
    }
    
    @IBAction func addToCalendarButton(sender: AnyObject) {
        saveData()
        
        let myCalendar:NSCalendar = NSCalendar.currentCalendar()
        
        let myStartDateComponents:NSDateComponents = NSDateComponents()
        let myEndDateComponents:NSDateComponents = NSDateComponents()
        
        myStartDateComponents.year = myCalendar.component(NSCalendarUnit.Year, fromDate: dateFromRSDF!)
        myStartDateComponents.month = myCalendar.component(NSCalendarUnit.Month, fromDate: dateFromRSDF!)
        myStartDateComponents.day = myCalendar.component(NSCalendarUnit.Day, fromDate: dateFromRSDF!)
        myStartDateComponents.hour = shiftInfo.startHour.integerValue
        myStartDateComponents.minute = shiftInfo.startMinute.integerValue
        
        if (shiftInfo.startHour == 12){
            myStartDateComponents.hour -= 12
        }
        
        if (shiftInfo.startAbbrev == "PM"){
            myStartDateComponents.hour += 12
        }
        
        myEndDateComponents.year = myCalendar.component(NSCalendarUnit.Year, fromDate: dateFromRSDF!)
        myEndDateComponents.month = myCalendar.component(NSCalendarUnit.Month, fromDate: dateFromRSDF!)
        myEndDateComponents.day = myCalendar.component(NSCalendarUnit.Day, fromDate: dateFromRSDF!)
        myEndDateComponents.hour = shiftInfo.endHour.integerValue
        myEndDateComponents.minute = shiftInfo.endMinute.integerValue
        
        if (shiftInfo.endAbbrev == "PM"){
            myEndDateComponents.hour += 12
        }
        
        let myStartDate:NSDate = myCalendar.dateFromComponents(myStartDateComponents)!
        let myEndDate:NSDate = myCalendar.dateFromComponents(myEndDateComponents)!
        
        switch (myStartDate.compare(myEndDate)) {
        case NSComparisonResult.OrderedAscending:
            saveEvent(withStartDate: myStartDate, andEndDate: myEndDate)
            performSegueWithIdentifier("confirmationToSuccess", sender: sender)
        case NSComparisonResult.OrderedSame:
            performSegueWithIdentifier("confirmationToFailureForSame", sender: sender)
        case NSComparisonResult.OrderedDescending:
            performSegueWithIdentifier("confirmationToFailureEndBeforeStart", sender: sender)
        }
    }
    
    @IBAction func startOverButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


    
}