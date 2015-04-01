//
//  ViewController.m
//  NSFormatterSharedInstance
//
//  Created by Timur Bernikowich on 30.03.15.
//  Copyright (c) 2015 Timur Bernikowich. All rights reserved.
//

#import "ViewController.h"
#import "NSFormatter+Application.h"

@interface ViewController ()

@property UISegmentedControl *segmentedControl;
@property (readonly) BOOL usingSharedInstances;
@property BOOL shouldShowLogs;
@property NSArray *testData;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Segmented control.
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Default", @"SharedInstance"]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedState:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentedControl;

    // Test data.
    // Let's imaging we have a big array of date strings received from server
    // and we want store it as is, but show in another format in table view cells.
    NSInteger numberOfDateStrings = 1000;
    NSMutableArray *testData = [NSMutableArray new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm";
    for (NSInteger index = 0; index < numberOfDateStrings; index++) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:index * 5 * 60];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [testData addObject:dateString];
    }
    self.testData = testData;

    // Setting to `NO` will speed up default implementation,
    // but anyway it's slower then `SharedInstance`.
    self.shouldShowLogs = YES;

    // Table view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - Segmented Control

- (void)segmentedControlChangedState:(id)sender
{
    [self.tableView reloadData];
}

- (BOOL)usingSharedInstances
{
    return (self.segmentedControl.selectedSegmentIndex);
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.testData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];

    // Initialize formatters according to settings.
    NSDateFormatter *toDateFormatter;
    NSDateFormatter *toStringFormatter;
    NSTimeInterval beginTimestamp = [NSDate timeIntervalSinceReferenceDate];

    if (self.usingSharedInstances) {
        // Shared "to date" and "to string" formatters.
        toDateFormatter = [NSDateFormatter toDateFormatter];
        toStringFormatter = [NSDateFormatter toStringFormatter];
    } else {
        if (self.shouldShowLogs) {
            NSLog(@"Such code will be slow, because it runs many times.");
        }

        // Default "to date" formatter implementation.
        toDateFormatter = [NSDateFormatter new];
        toDateFormatter.dateFormat = @"dd-MM-yyyy HH:mm";

        // Default "to date" formatter implementation.
        toStringFormatter = [NSDateFormatter new];
        toStringFormatter.dateStyle = NSDateFormatterShortStyle;
        toStringFormatter.timeStyle = NSDateFormatterShortStyle;
        toStringFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }

    // Generate test data.
    NSString *inputFormatDateString = self.testData[indexPath.row];
    NSDate *date = [toDateFormatter dateFromString:inputFormatDateString];
    NSString *preferredFormatDateString = [toStringFormatter stringFromDate:date];
    NSTimeInterval endTimestamp = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval takenTime = endTimestamp - beginTimestamp;

    // Update cell.
    static NSInteger milisecondsInSeconds = 1000;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %.1fms", preferredFormatDateString, (takenTime * milisecondsInSeconds)];

    return cell;
}

- (void)didReceiveMemoryWarning
{
    if (self.shouldShowLogs) {
        NSLog(@"Run call `cleanUpMemory` method when `didReceiveMemoryWarning` called. This will release all shared formatters. If shared instances of formatters will be called again, they will be recreated.");
    }
    [NSFormatter cleanUpMemory];
}

@end
