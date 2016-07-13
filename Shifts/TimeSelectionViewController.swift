//
//  MainViewController.swift
//  Shifts
//
//  Created by Ryan on 11/20/14.
//  Copyright (c) 2014 Full Screen Ahead. All rights reserved.
//

import UIKit
import EventKit


class TimeSelectionViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet var startHourOutletCollection: [UIButton]!
    @IBOutlet var endTimeOutletCollection: [UIButton]!
    
    let customCornerRadius:CGFloat = 12.0
    let customBorderWidth:CGFloat = 1.0
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
        setupButtons()
        refreshDayLabel()
        setDefaultStartTimeAndEndTimeLabels()
        refreshTimeLabels()
    }
    
    
    func checkForCalendarAccess() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            // If you already have access to the Calendar
            break
        case .Denied:
            // If you were not given access to the Calendar
            self.navigationController?.popToRootViewControllerAnimated(true)
        case .NotDetermined:
            // If it hasn't been asked to the user yet
            
            // Request permisson to the calendar
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                {(granted: Bool, error: NSError?) -> Void in
                    if granted {
                    
                    } else {
                        // If you were not given access to the Calendar by the user
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
            })
        default:
            print("Default Case")
        }
    }
    
    func removeTimers() {
        timer.invalidate()
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
