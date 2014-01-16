//
//  FlxToolkitFunctions.h
//  FlxToolkit
//
//  Created by Aaron Hayman on 1/15/14.
//  Copyright (c) 2014 Aaron Hayman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlxAlert.h"

#ifdef DEBUG
    #define FlxLogS(fmt, ...) DebugLog(fmt, ##__VA_ARGS__)
    #define FlxLogF() DebugLog(@"%s:%d", __PRETTY_FUNCTION__, __LINE__)
    #define FlxLog(...) DebugLog(@"%s:%d - %@", __PRETTY_FUNCTION__, __LINE__, [NSString  stringWithFormat:__VA_ARGS__,nil])
    #define Debug(x) x
    #define DebugIf(x, y) x
#else
    #define FlxLog(...)
    #define FlxLogF()
    #define FlxLogS(...)
    #define Debug(x)
    #define DebugIf(x, y) y
#endif

#define SuppressSelectorWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#define FlxAssert(expression, ...) \
    if(!(expression)) { \
        NSString *assert_temp_string = [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__, nil]]; \
        NSAssert(NO, assert_temp_string);\
        abort(); \
    }

//This allows you to define a nonfailing exception throw. For example, if you wanted to report the error to a service
#ifndef NonFailingException
    #define NonFailingException(x) FlxLog(x)
#endif
/**
 This will execute the success block only if the condition succeeds
 **/
#define FlxTrySucceed(expression, error, alert, onSuccess) \
    if (!(expression)){ \
        if (alert){ \
            [FlxAlert displayAlertWithTitle:@"Error!" message:[NSString stringWithFormat:@"Something went wrong! We're really sorry about that.\n\nHere's the Error:\n   %@", error]]; \
        } \
        NSString *exception = [NSString stringWithFormat:@"Try Failure.\n  Description: %@. \n  Failure: %s in %s on line %s:%d.", error, #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__];\
        NonFailingException(exception); \
    } else { \
        onSuccess; \
    }
/**
 This will execute the failure block only if the condition fails
 **/
#define FlxTry(expression, error, alert, onFailure) \
    if (!(expression)){ \
        if (alert){ \
            [FlxAlert displayAlertWithTitle:@"Error!" message:[NSString stringWithFormat:@"Something went wrong! We're really sorry about that.\n\nHere's the Error:\n   %@", error]]; \
        } \
        NSString *exception = [NSString stringWithFormat:@"Try Failure.\n  Description: %@. \n  Failure: %s in %s on line %s:%d.", error, #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__];\
        NonFailingException(exception); \
        onFailure; \
    }

BOOL CGRectIsEqualToRect(CGRect rect1, CGRect rect2);


void DebugLog(NSString *format,...);

//Device Major Version
NSUInteger DeviceSystemMajorVersion(void);

#define IsOSPre7 (DeviceSystemMajorVersion() < 7)

void fBound(CGFloat *x, CGFloat lower, CGFloat upper);

void ExecuteBlockAfterDelay(NSTimeInterval, void (^)(void));
