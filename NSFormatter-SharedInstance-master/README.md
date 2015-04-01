NSFormatter+SharedInstance
=================

Category on NSFormatter to simplify formatters sharing and memory managment.

NSFormatter and its subclasses have an speceific behaviour: they are too heavy for many times initializations and should not be used in different threads.

Lets simplify formatters' creation and managment with simple and powerful category!

Best practicles.
---------------
Create category for application, which will include getters for all needed formatters.
Your header file should look like this one:
```objc
#import "NSFormatter+SharedInstance.h"

@interface NSFormatter (Application)

+ (NSDateFormatter *)toDateFormatter;
+ (NSDateFormatter *)toStringFormatter;

@end
```
And implementation:
```objc
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
```
Import your category. Since now you share single instance of formatter all over the app. Initialization will be called only once per thread (it required by NSFormatter's thread vulnerability).
```objc
#import "NSFormatter+Application.h"
...
// Shared "to date" and "to string" formatters.
toDateFormatter = [NSDateFormatter toDateFormatter];
toStringFormatter = [NSDateFormatter toStringFormatter];
```
You can call `cleanUpMemory` in `didReceiveMemoryWarning` method, it releases all shared instances of formatters.
```objc
- (void)didReceiveMemoryWarning
{
    [NSFormatter cleanUpMemory];
}
```

## Category Requirements

Tested only on iOS 6.0 and later. Compatible with ARC only.

## Test Project Requirements

The Xcode test project uses the XCTest framework and so requires >= Xcode 5.

## Usage

Add `NSFormatter+SharedInstance.h/m` into your project, or `pod 'NSFormatter+SharedInstance'` using CocoaPods.
