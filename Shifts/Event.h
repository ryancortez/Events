//
//  Event.h
//  Events
//
//  Created by Ryan on 1/15/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) NSNumber *startYear;
@property (strong, nonatomic) NSNumber *startMonth;
@property (strong, nonatomic) NSNumber *startDay;
@property (strong, nonatomic) NSNumber *startHour;
@property (strong, nonatomic) NSNumber *startMinute;
@property (strong, nonatomic) NSString *startAbbrev;

@property (strong, nonatomic) NSNumber *endHour;
@property (strong, nonatomic) NSNumber *endMinute;
@property (strong, nonatomic) NSString *endAbbrev;

@property (strong, nonatomic) NSString *blinkingText;


- (NSDateFormatter *) dateAndTimeFormatter;
- (NSDateFormatter *) timeFormatter;
- (NSDateFormatter *) dateFormatter;

@end
