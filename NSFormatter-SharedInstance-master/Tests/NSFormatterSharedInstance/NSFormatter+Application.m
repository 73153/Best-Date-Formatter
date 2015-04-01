//
//  NSFormatter+Application.m
//  NSFormatterSharedInstance
//
//  Created by Timur Bernikowich on 31.03.15.
//  Copyright (c) 2015 Timur Bernikowich. All rights reserved.
//

#import "NSFormatter+Application.h"

@implementation NSFormatter (Application)

+ (NSDateFormatter *)toDateFormatter
{
    return [NSDateFormatter sharedFormatterWithIdentifier:@"TestToDateFormatter" configurationHandler:^(NSDateFormatter *dateFormatter) {
        NSLog(@"This code runs once for first NSDateFormatter.");
        dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm";
    }];
}

+ (NSDateFormatter *)toStringFormatter
{
    return [NSDateFormatter sharedFormatterWithIdentifier:@"TestToDateFormatter" configurationHandler:^(NSDateFormatter *dateFormatter) {
        NSLog(@"And once for second NSDateFormatter.");
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }];
}

@end
