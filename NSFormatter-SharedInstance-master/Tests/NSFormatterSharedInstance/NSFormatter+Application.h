//
//  NSFormatter+Application.h
//  NSFormatterSharedInstance
//
//  Created by Timur Bernikowich on 31.03.15.
//  Copyright (c) 2015 Timur Bernikowich. All rights reserved.
//

#import "NSFormatter+SharedInstance.h"

@interface NSFormatter (Application)

+ (NSDateFormatter *)toDateFormatter;
+ (NSDateFormatter *)toStringFormatter;

@end
