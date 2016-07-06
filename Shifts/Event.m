//
//  Event.m
//  Events
//
//  Created by Ryan on 1/15/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)init {
    if (self = [super init])  {
        self.title = @"";
        self.location = @"";
        
        self.startYear = 0;
        self.startMonth = 0;
        self.startDay = 0;
        self.startHour = 0;
        self.startMinute = 0;
        self.startAbbrev = 0;
        
        self.endHour = 0;
        self.endMinute = 0;
        self.endAbbrev = 0;
        self.blinkingText = @"0";
        
    }
    return self;
}


- (NSDateFormatter *) dateAndTimeFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"MMMM d, h:mm a"];
    
    
    return dateFormatter;
}

- (NSDateFormatter *) dateFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    
    return dateFormatter;
}

- (NSDateFormatter *) timeFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    return dateFormatter;
}

@end
