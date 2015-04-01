//
//  NSFormatterSharedInstanceTests.m
//  NSFormatterSharedInstanceTests
//
//  Created by Timur Bernikowich on 30.03.15.
//  Copyright (c) 2015 Timur Bernikowich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSFormatter+SharedInstance.h"

@interface NSFormatterSharedInstanceTests : XCTestCase

@end

@implementation NSFormatterSharedInstanceTests

/*!
 * @method -testNumberOfFormatterInitializations
 * Configuration handler called exactly once,
 * until `cleanUpMemory` called.
 */
- (void)testNumberOfFormatterInitializations
{
    __block NSInteger numberOfFormatterInitializations = 0;
    NSInteger numberOfInvocations = 100;
    for (NSInteger index = 0; index < numberOfInvocations; index++) {
        [NSDateFormatter sharedFormatterWithIdentifier:@"TestNumberOfInitializationsFormatter" configurationHandler:^(NSFormatter *formatter) {
            numberOfFormatterInitializations++;
        }];
    }
    XCTAssert((numberOfFormatterInitializations == 1), @"Number of initializations for formatter with same ID should be equal to 1.");
}

/*!
 * @method -testMemoryCleanUp
 * `cleanUpMemory` method should release all shared instances.
 */
- (void)testMemoryCleanUp
{
    __weak NSDateFormatter *dateFormatter = [NSDateFormatter sharedFormatterWithIdentifier:@"TestMemoryCleanUpFormatter" configurationHandler:nil];
    XCTAssert((dateFormatter), @"Method `sharedFormatterWithIdentifier` should create shared instances.");
    [NSDateFormatter cleanUpMemory];
    XCTAssert((!dateFormatter), @"Method `cleanUpMemory` should release all shared instances.");
}

/*!
 * @method -testPerformance
 * Getting shared formatter works really fast.
 */
- (void)testPerformance
{
    [self measureBlock:^{
        NSInteger numberOfInvocations = 100000;
        for (NSInteger index = 0; index < numberOfInvocations; index++) {
            [NSDateFormatter sharedFormatterWithIdentifier:@"TestNumberOfInitializationsFormatter" configurationHandler:nil];
        }
    }];
}

@end
