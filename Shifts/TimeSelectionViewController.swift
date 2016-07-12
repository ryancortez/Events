//
//  MainViewController.swift
//  Shifts
//
//  Created by Ryan on 11/20/14.
//  Copyright (c) 2014 Full Screen Ahead. All rights reserved.
//

import UIKit
import EventKit


class TimeSelectionViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet var startHourOutletCollection: [UIButton]!
    @IBOutlet var endTimeOutletCollection: [UIButton]!
    @IBOutlet weak var titleOutlet: UITextView!
    
    let customCornerRadius:CGFloat = 12.0
    let customBorderWidth:CGFloat = 1.0
    let eventTitleKey = "Event Title"
    var eventTitleValue: AnyObject = "Add title here"
    var shiftInfo:Event = Event()
    var dateFromRSDF: NSDate?
    let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    
    var blinkStatus: Bool = false
    var timer: NSTimer = NSTimer()
    var label: UILabel = UILabel()
    var range: NSRange = NSRange()
    
    struct DatePickerDate {
        var year:Int
        var month:Int
        var day:Int
    }
    
    let customBlueColor = UIColor(red: 0.31, green: 0.77, blue: 1.0, alpha: 1.0)
    let customGreenColor = UIColor(red: 0.37, green: 0.93, blue: 0.53, alpha: 1.0)
    let customGraycolor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1.0)
    let customLightGraycolor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 0.4)
    
    override func viewWillAppear(animated: Bool) {
        removeTimers()
        setTitleDelegate()
        setupButtons()
        refreshDayLabel()
        setDefaultStartTimeAndEndTimeLabels()
        refreshTimeLabels()
        setupTitleTextView()
    }
    
    func setupTitleTextView() {
        if (titleOutlet != nil) {
//            titleOutlet.layer.cornerRadius = customCornerRadius
//            titleOutlet.layer.borderWidth = customBorderWidth
//            titleOutlet.layer.borderColor = customGraycolor.CGColor
            if (titleOutlet.text == "Add title here"){
                titleOutlet.textColor = customGraycolor
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        titleOutlet.textColor = UIColor.darkGrayColor()
    }
    
    func removeTimers() {
        timer.invalidate()
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
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfURL: path)
        print("Loaded Settings.plist file is --> \(resultDictionary?.description)")
        
        let myDict = NSDictionary(contentsOfURL: path)
        if let dict = myDict {
            // Loading values
            eventTitleValue = dict.objectForKey(eventTitleKey)!
        } else {
            print("WARNING: Couldn't create dictionary from Settings.plist! Default values will be used!")
        }
    }
    
    func saveData() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("Settings.plist")
        
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        // Saving values
        dict.setObject(eventTitleValue, forKey: eventTitleKey)
        
        // Writing to Settings.plist
        dict.writeToFile(path, atomically: false)
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved Settings.plist file is --> \(resultDictionary?.description)")
    }
    
    func blink() {
        
        if(blinkStatus == false){
            let text = NSMutableAttributedString(attributedString: label.attributedText!)
            text.addAttributes([NSForegroundColorAttributeName : customLightGraycolor], range: self.range)
            UIView.animateWithDuration(1.5, animations: { self.label.attributedText = text  }, completion: {(value: Bool) in })
            
            
            blinkStatus = true;
        }else {
            let text = NSMutableAttributedString(attributedString: label.attributedText!)
            text.addAttributes([NSForegroundColorAttributeName : customGraycolor] , range: self.range)
            UIView.animateWithDuration(1.5, animations: { self.label.attributedText = text   }, completion: {(value: Bool) in })
            blinkStatus = false;
        }
    }
    
    func blinkTextInLabel (label: UILabel, withRange rangeParameter: NSRange) {
        self.range = rangeParameter
        self.label = label
        if (label.text?.characters.count == 8) {
            self.range = NSMakeRange(self.range.location + 1, self.range.length)
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(TimeSelectionViewController.blink), userInfo: nil, repeats: true)
    }
    
    func setTitleDelegate() {
        if titleOutlet != nil {
            titleOutlet.delegate = self
            self.loadData()
            titleOutlet.text = eventTitleValue as! String
        }
    }
    
    func refreshTimeLabels() {
        // Refresh the Start Time and End Time label for each view
        startTimeLabel.text = (shiftInfo.startHour.stringValue) + ":" + shiftInfo.startMinute.stringValue.stringByPaddingToLength(2, withString: "0", startingAtIndex: 0) + " " + shiftInfo.startAbbrev
        endTimeLabel.text = (shiftInfo.endHour.stringValue) + ":" + shiftInfo.endMinute.stringValue.stringByPaddingToLength(2, withString: "0", startingAtIndex: 0) + " " + shiftInfo.endAbbrev
    }
    
    func refreshDayLabel() {
        // Refresh the Day label at the top of the screen
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        dayLabel.text = dateFormatter.stringFromDate(dateFromRSDF!)
    }
    
    func setupButtons() {
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 18)!]
            , forState: UIControlState.Normal)
        
        if (startHourOutletCollection != nil){
            for button in startHourOutletCollection{
                button.backgroundColor = customBlueColor
                button.layer.cornerRadius = customCornerRadius
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
        
        if (endTimeOutletCollection != nil){
            for button in endTimeOutletCollection{
                button.backgroundColor = customGreenColor
                button.layer.cornerRadius = customCornerRadius
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
    }

    func setDefaultStartTimeAndEndTimeLabels() {
        // If these values are not set, they will be set to these defaults (You were getting crashes, because Swift thinks they are optionals, and was stating that it was "Unwrapping an optional that was nil"
        if (shiftInfo.title == nil){
            shiftInfo.title = ""
        }
        if (shiftInfo.title == nil){
            shiftInfo.location = ""
        }
        if (shiftInfo.startYear == nil){
            shiftInfo.startYear = 00
        }
        if (shiftInfo.startMonth == nil){
            shiftInfo.startMonth = 00
        }
        if (shiftInfo.startDay == nil){
            shiftInfo.startDay = 00
        }
        if (shiftInfo.startHour == nil){
            shiftInfo.startHour = 00
        }
        if (shiftInfo.startMinute == nil){
            shiftInfo.startMinute = 00
        }
        if (shiftInfo.startAbbrev == nil){
            shiftInfo.startAbbrev = "AM"
        }
        if (shiftInfo.endHour == nil){
            shiftInfo.endHour = 00
        }
        if (shiftInfo.endMinute == nil){
            shiftInfo.endMinute = 00
        }
        if (shiftInfo.endAbbrev == nil){
            shiftInfo.endAbbrev = "AM"
        }
}

    @IBAction func startHourButton(sender: AnyObject) {
        
        // Announces when model is changing
        let buttonTitle = sender.currentTitle!
        
        // Change the model by adding the button's title data
        let formatter:NSNumberFormatter = NSNumberFormatter()
        let aNumber = formatter.numberFromString(buttonTitle!)
        
        shiftInfo.startHour = aNumber
        
        // UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
        performSegueWithIdentifier("startingHourToStartingMinute", sender: sender)
        
    }
    @IBAction func startMinuteButton(sender: AnyObject) {
        
        var buttonTitle = sender.currentTitle!
        let formatter:NSNumberFormatter = NSNumberFormatter()
        buttonTitle = String(buttonTitle!.characters.dropFirst())
        let aNumber = formatter.numberFromString(buttonTitle!)
        
        // Change the model by adding the button's title data
        shiftInfo.startMinute = aNumber
        blinkTextInLabel(startTimeLabel, withRange: NSMakeRange(3, 2))
        
        performSegueWithIdentifier("startMinuteToAbbreviation", sender: sender)
    }
    @IBAction func startAbbreviationButton(sender: AnyObject) {
        
        let buttonTitle = sender.currentTitle!
        shiftInfo.startAbbrev = buttonTitle!

        performSegueWithIdentifier("abberviationToEndHour", sender: sender)
    }
    @IBAction func endingHourButton(sender: AnyObject) {
        
        let buttonTitle = sender.currentTitle!
        
        // Change the model by adding the button's title data
        let formatter:NSNumberFormatter = NSNumberFormatter()
        let aNumber = formatter.numberFromString(buttonTitle!)
        
        shiftInfo.endHour = aNumber
        
        performSegueWithIdentifier("endHourToEndMinute", sender: sender)
    }
    @IBAction func endingMinuteButton(sender: AnyObject) {
        
        var buttonTitle = sender.currentTitle!
        
        // Change the model by adding the button's title data
        let formatter:NSNumberFormatter = NSNumberFormatter()
        buttonTitle = String(buttonTitle!.characters.dropFirst())
        
        let aNumber = formatter.numberFromString(buttonTitle!)
        
        shiftInfo.endMinute = aNumber
        
        performSegueWithIdentifier("endingMinuteToAbbreviation", sender: sender)
    }
    @IBAction func endingAbbrevationButton(sender: AnyObject) {
        
        let buttonTitle = sender.currentTitle!
        shiftInfo.endAbbrev = buttonTitle!
        
        performSegueWithIdentifier("abbreviationToConfirmation", sender: sender)
    }
    
    
    
    @IBAction func addToCalendarButton(sender: AnyObject) {
        
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
                        
                        let event = EKEvent(eventStore: eventStore)
                        
                        event.title = "Event" // Sets event's title
                        event.startDate = NSDate() // Sets event's start date
                        event.endDate = event.startDate.dateByAddingTimeInterval(20000) // Sets event's end date
                        event.calendar = eventStore.defaultCalendarForNewEvents // Selects default calendar
                        
                        var saveError : NSError? = nil // Initially sets errors to nil
                        do {
                            try eventStore.saveEvent(event, span: .ThisEvent, commit: true)
                        } catch let error as NSError {
                            saveError = error
                        } catch {
                            fatalError()
                        } // Commits changes and allows saveEvent to change error from nil
                        
                        //// Following checks for errors and prints result to Debug Area ////
                        if saveError != nil {
                            print("Saving event to Calendar failed with error: \(saveError!)")
                        } else {
                            print("Successfully saved '\(event.title)' to '\(event.calendar.title)' calendar.")
                        }

                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case Default")
        }
    }
    
    func saveEvent(toEventStore eventStore: EKEventStore, withStartdate startDate: NSDate, andEndDate endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = titleOutlet.text // Sets event's title
        event.startDate = startDate // Sets event's start date
        event.endDate = endDate // Sets event's end date
        event.calendar = eventStore.defaultCalendarForNewEvents // Selects default calendar
        
        var saveError : NSError? = nil // Initially sets errors to nil
        do {
            try eventStore.saveEvent(event, span: .ThisEvent, commit: true)
        } catch let error as NSError {
            saveError = error
        } // Commits changes and allows saveEvent to change error from nil
        
        //// Following checks for errors and prints result to Debug Area ////
        if saveError != nil {
            print("Saving event to Calendar failed with error: \(saveError!)")
        } else {
            print("Successfully saved '\(event.title)' to '\(event.calendar.title)' calendar.")
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            titleOutlet.resignFirstResponder()
            eventTitleValue = titleOutlet.text
            self.saveData()
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier != "confirmationToSuccess" && segue.identifier != "confirmationToFailureForSame" && segue.identifier != "confirmationToFailureEndBeforeStart" ){
            
            if segue.destinationViewController is TimeSelectionViewController {
                let destinationVC = segue.destinationViewController as! TimeSelectionViewController
                destinationVC.shiftInfo = shiftInfo
                destinationVC.dateFromRSDF = dateFromRSDF
            }
        }
    }
}
