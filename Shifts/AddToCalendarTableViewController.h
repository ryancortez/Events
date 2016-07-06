//
//  AddToCalendarTableViewController.h
//  Events
//
//  Created by Ryan on 4/9/14.
//  Copyright (c) 2014 Ryan. All rights reserved.


#import <UIKit/UIKit.h>
#import "Event.h"

@interface AddToCalendarTableViewController : UITableViewController <UITextFieldDelegate>

@property Event *event;

@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;

@end
