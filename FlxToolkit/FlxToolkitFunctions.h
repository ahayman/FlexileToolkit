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
    #define FlxLogS(fmt, ...)
    #define FlxLogF()
    #define FlxLog(...)
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

#ifdef FlxLog
#define FlxAssert(expression, ...) \
    if(!(expression)) { \
        FlxLog(@"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__, nil]); \
        NSAssert(NO, @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__, nil]); \
        abort(); \
    }
#else
#define FlxAssert(expression, ...) \
    if(!(expression)) { \
        NSAssert(NO, @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__, nil]); \
        abort(); \
    }
#endif

//You can define a NonFailingException(x) to customize the behavior of FlxTry & FlxTrySucceed
/**
 This will execute the success block only if the condition succeeds
 **/
#ifdef NonFailingException
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
#else
#define FlxTrySucceed(expression, error, alert, onSuccess) \
    if (!(expression)){ \
        if (alert){ \
            [FlxAlert displayAlertWithTitle:@"Error!" message:[NSString stringWithFormat:@"Something went wrong! We're really sorry about that.\n\nHere's the Error:\n   %@", error]]; \
        } \
    } else { \
        onSuccess; \
    }
#endif
/**
 This will execute the failure block only if the condition fails
 **/
#ifdef NonFailingException
#define FlxTry(expression, error, alert, onFailure) \
    if (!(expression)){ \
        if ((alert)){ \
            [FlxAlert displayAlertWithTitle:@"Error!" message:[NSString stringWithFormat:@"Something went wrong! We're really sorry about that.\n\nHere's the Error:\n   %@", error]]; \
        } \
        NSString *exception = [NSString stringWithFormat:@"Try Failure.\n  Description: %@. \n  Failure: %s in %s on line %s:%d.", error, #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__];\
        NonFailingException(exception); \
        onFailure; \
    }
#else
#define FlxTry(expression, error, alert, onFailure) \
    if (!(expression)){ \
        if ((alert)){ \
            [FlxAlert displayAlertWithTitle:@"Error!" message:[NSString stringWithFormat:@"Something went wrong! We're really sorry about that.\n\nHere's the Error:\n   %@", error]]; \
        } \
        onFailure; \
    }
#endif

BOOL CGRectIsEqualToRect(CGRect rect1, CGRect rect2);


void DebugLog(NSString *format,...);

//Device Major Version
NSUInteger DeviceSystemMajorVersion(void);

#define IsOSPre7 (DeviceSystemMajorVersion() < 7)

void fBound(CGFloat *x, CGFloat lower, CGFloat upper);

void ExecuteBlockAfterDelay(NSTimeInterval, void (^)(void));
