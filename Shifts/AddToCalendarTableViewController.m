//
//  AddToCalendarTableViewController.m
//  Events
//
//  Created by Ryan on 4/9/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "AddToCalendarTableViewController.h"
#import <EventKit/EventKit.h>

@interface AddToCalendarTableViewController ()

@property (nonatomic, strong) EKEventStore *classWideEventStore;

@end

@implementation AddToCalendarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // This is checking if the event is saving across view controllers
//    NSLog(@"\n\n The Add to Calendar View has appeared. \n\n _event.title = %@ \n _event.location = %@ \n _event.startDate = %@ \n _event.endDate = %@", _event.title, _event.location, [[_event dateAndTimeFormatter] stringFromDate:_event.startDate],[[_event dateAndTimeFormatter] stringFromDate:_event.endDate] );
//    
//    // Displaying the event data inside the table view labels
//    
//    self.eventTitle.text = _event.title;
//    self.location.text = _event.location;
//    
//    if (_event.allDay) {
//        
//        self.startDate.text = [[_event dateFormatter] stringFromDate:_event.startDate];
//        self.endDate.text = @"";
//        
//    } else{
//        
//    self.startDate.text = [[_event dateAndTimeFormatter] stringFromDate:_event.startDate];;
//    self.endDate.text = [[_event dateAndTimeFormatter] stringFromDate:_event.endDate];
//        
//    }
    
    self.eventTitle.delegate = self;
}

//// Decides what happens when a TableView Cell is pressed
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 0) {
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    
//    
//}


//- (IBAction)addToCalendarButton:(id)sender {
//    
//    // If you have access to the calendar make an event, if not ask for calendar access.
//    // If you do have access, create an event
//    [self checkIfYouHaveAccessToTheCalendar];
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}






//// Checks if you have access to the calendar.
//-(BOOL)checkIfYouHaveAccessToTheCalendar
//{
//    
//    NSLog(@"Checked if customer had access to calendar");
//    
//    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
//    
//    BOOL accessGranted = NO;
//    
//    switch (status)
//    {
//            
//            // Update our UI if the user has granted access to their Calendar
//        case EKAuthorizationStatusAuthorized: [self createEvent];
//            accessGranted = YES;
//            return accessGranted;
//            break;
//            // Prompt the user for access to Calendar if there is no definitive answer
//        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
//            break;
//            // Display a message if the user has denied or restricted access to Calendar
//        case EKAuthorizationStatusDenied:
//        case EKAuthorizationStatusRestricted:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help!" message:@"Events won't work unless you go to Settings > Privacy > Calendars\nThen, turn on Events"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return accessGranted;
//}
//
//// Create an event and handle if you don't have access to the counter.
//-(void)createEvent
//{

//    if (_event.allDay) {
//        
//        
//        EKEventStore *eventStore = [[EKEventStore alloc] init];
//        _classWideEventStore = eventStore;
//        
//        // Create Event object to eventually put into an EventStore.
//        EKEvent *myEvent  = [EKEvent eventWithEventStore:eventStore];
//        
//        // Set the event as an All-Day Event
//        myEvent.title     = _event.title;
//        myEvent.startDate = _event.startDate;
//        myEvent.endDate   = _event.endDate;
//        myEvent.allDay = YES;
//        [myEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
//        
//        [eventStore saveEvent:myEvent span:EKSpanThisEvent error:nil];
//        
//        // This is checking if the event is saving across view controllers
//        NSLog(@"\n\n ADDED THIS EVENT TO THE CALENDAR: \n\n _event.title = %@ \n _event.location = %@ \n _event.startDate = %@", _event.title, _event.location, [[_event dateFormatter] stringFromDate:_event.startDate] );
//        
//    }
//    else{
    
//        
//        // Create a storage for Calendar Events.
//        EKEventStore *eventStore = [[EKEventStore alloc] init];
//        _classWideEventStore = eventStore;
//        
//        // Create Event object to eventually put into an EventStore.
//        EKEvent *myEvent  = [EKEvent eventWithEventStore:eventStore];
//        
//        // Set the newly made event with the customer's choices.
//        myEvent.title     = _event.title;
//        myEvent.startDate = _event.startDate;
//        myEvent.endDate   = _event.endDate;
//        [myEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
//        
//        [eventStore saveEvent:myEvent span:EKSpanThisEvent error:nil];
//        
//        // This is checking if the event is saving across view controllers
//        NSLog(@"\n\n ADDED THIS EVENT TO THE CALENDAR: \n\n _event.title = %@ \n _event.location = %@ \n _event.startDate = %@ \n _event.endDate = %@", _event.title, _event.location, [[_event dateAndTimeFormatter] stringFromDate:_event.startDate],[[_event dateAndTimeFormatter] stringFromDate:_event.endDate] );
//        
//    }
//}

//// Display window that confirms user made event.
//- (void) eventCreationConfirmation {
//    
//    if (_event.allDay) {
//        
//        NSDateFormatter *dateFormatter = [_event dateAndTimeFormatter];
//        [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"'%@'", _event.title]
//                                                        message:[NSString stringWithFormat: @"%@\nAll-Day",[dateFormatter stringFromDate:_event.startDate]]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Confirm"
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//    }
//    else{
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"'%@' has been added", _event.title]
//                                                        message:[NSString stringWithFormat: @"\n%@ - %@",[[_event dateAndTimeFormatter] stringFromDate:_event.startDate], [[_event customTimeFormatter] stringFromDate:_event.endDate]]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}


// Request access to the Calendar for the first time when you open the app.
//-(void)requestCalendarAccess
//{
//    NSLog(@"Requested Access to Calendar.");
//    
//    BOOL needsToRequestAccessToEventStore = NO; // iOS 5 behavior
//    EKAuthorizationStatus authorizationStatus = EKAuthorizationStatusAuthorized; // iOS 5 behavior
//    if ([[EKEventStore class] respondsToSelector:@selector(authorizationStatusForEntityType:)]) {
//        authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
//        needsToRequestAccessToEventStore = (authorizationStatus == EKAuthorizationStatusNotDetermined);
//    }
//    
//    if (needsToRequestAccessToEventStore) {
//        NSLog(@"Ran if statement inside requestCalendarAccess");
//        [_classWideEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            if (granted) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // You can use the event store now
//                });
//            }
//        }];
//    } else if (authorizationStatus == EKAuthorizationStatusAuthorized) {
//        // You can use the event store now
//        
//        [self createEvent];
//    } else {
//        // Access denied
//    }
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.eventTitle resignFirstResponder];
    
    _event.title = self.eventTitle.text;
    NSLog(@"\n\n_event.title has been updated to: %@", _event.title);
    
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [[segue destinationViewController] setEvent:_event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
