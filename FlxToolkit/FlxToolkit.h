//
//  FlxToolkit.h
//  Flexile
//
//  Created by Aaron Hayman on 1/14/14.
//
//

#import <Foundation/Foundation.h>

#import "FlxToolkitExtensions.h"

#import "FlxLinkedList.h"
#import "FlxCollection.h"
#import "FlxOrderedCollection.h"
#import "FlxWeakContainer.h"
//Some Helper Classes
#import "FlxReferencedExecution.h"
#import "FlxKVObserver.h"
#import "FlxWeakTimer.h"
#import "FlxAlert.h"
#import "FlxUIImagePicker.h"
//Gesture Recognizers
#import "FlxDragGestureRecognizer.h"
#import "FlxlPinchGestureRecognizer.h"
#import "FlxTapGestureRecognizer.h"


#define SuppressSelectorWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    #define XCode5Code(code, alt) code
#else
    #define XCode5Code(code, alt) alt
#endif

#define FlxAssert(expression, ...) \
    if(!(expression)) { \
        NSString *__MAAssert_temp_string = [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:__VA_ARGS__, nil]]; \
        CLS_LOG(@"%@", __MAAssert_temp_string);\
        NSAssert(NO, __MAAssert_temp_string);\
        abort(); \
    }

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


BOOL CGRectIsEqualToRect(CGRect rect1, CGRect rect2);


void DebugLog(NSString *format,...);

//Device Major Version
NSUInteger DeviceSystemMajorVersion(void);

#define IsOSPre7 (DeviceSystemMajorVersion() < 7)

void fBound(CGFloat *x, CGFloat lower, CGFloat upper);

void ExecuteBlockAfterDelay(NSTimeInterval, void (^)(void));

@protocol IndexedSubscripting <NSObject>
- (id)objectAtIndexedSubscript:(NSUInteger)index;
@optional
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;
@end

@protocol KeyedSubscripting <NSObject>
- (id)objectForKeyedSubscript:(id)key;
@optional
- (void)setObject:(id)obj forKeyedSubscript:(id)key;
@end