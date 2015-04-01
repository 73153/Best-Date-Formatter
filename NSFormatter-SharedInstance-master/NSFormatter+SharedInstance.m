//
//  NSFormatter+SharedInstance.m
//  NSFormatterSharedInstance
//
//  Created by Timur Bernikowich on 30.03.15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Timur Bernikowich. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSFormatter+SharedInstance.h"

NSString *const NSFormatterSharedInstanceDictionaryKey = @"NSFormatterSharedInstanceDictionaryKey";

@implementation NSFormatter (SharedInstance)

+ (instancetype)sharedFormatterWithIdentifier:(id <NSObject, NSCopying>)formatterIdentifier
                         configurationHandler:(void (^)(id formatter))configurationHandler
{
    // Check if identifier is correct.
    BOOL identifierCanBeKey = [formatterIdentifier conformsToProtocol:NSProtocolFromString(@"NSCoding")];
    NSAssert(identifierCanBeKey, @"NSFormatter+SharedInstance: `formatterIdentifier` should conforms to `NSObject` and `NSCopying` protocols");

    // Get formatter from thread dictionary.
    NSMutableDictionary *sharedFormattersDictionary = [self threadSharedFormattersDictionary];
    NSFormatter *sharedFormatter = sharedFormattersDictionary[formatterIdentifier];

    // Create new if needed.
    if (!sharedFormatter) {
        sharedFormatter = [self new];
        if (configurationHandler) {
            configurationHandler(sharedFormatter);
        }
        sharedFormattersDictionary[formatterIdentifier] = sharedFormatter;
    }
    
    return sharedFormatter;
}

+ (void)cleanUpMemory
{
#warning Clean up memory for all threads.
    [self removeSharedFormattersDictionaryInThread:[NSThread currentThread]];
}

#pragma mark - Helpers

+ (NSMutableDictionary *)threadSharedFormattersDictionary
{
    // Lazy initializer for shared formatters dictionaries.
    NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
    NSMutableDictionary *threadSharedFormattersDictionary = threadDictionary[NSFormatterSharedInstanceDictionaryKey];
    if (!threadSharedFormattersDictionary) {
        threadSharedFormattersDictionary = [NSMutableDictionary new];
        threadDictionary[NSFormatterSharedInstanceDictionaryKey] = threadSharedFormattersDictionary;
    }
    return threadSharedFormattersDictionary;
}

+ (void)removeSharedFormattersDictionaryInThread:(NSThread *)thread
{
    NSMutableDictionary *threadDictionary = thread.threadDictionary;
    [threadDictionary removeObjectForKey:NSFormatterSharedInstanceDictionaryKey];
}

@end
