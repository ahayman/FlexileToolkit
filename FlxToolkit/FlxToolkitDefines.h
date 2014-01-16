//
//  NSObject_FlxToolkitDefines.h
//  FlxToolkit
//
//  Created by Aaron Hayman on 1/15/14.
//  Copyright (c) 2014 Aaron Hayman. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FlxAlert.h"

//Convenient Animation Durations
#define VeryShortAnimationDuration .2f
#define ShortAnimationDuration .25f
#define StandardAnimationDuration .3333333333f
#define LongAnimationDuration .4f

//Convenience Macros for freakishly long names or commonly used method calls
#define MinX(rect) CGRectGetMinX(rect)
#define MaxX(rect) CGRectGetMaxX(rect)
#define MidX(rect) CGRectGetMidX(rect)
#define MinY(rect) CGRectGetMidY(rect)
#define MaxY(rect) CGRectGetMaxY(rect)
#define MidY(rect) CGRectGetMidY(rect)
#define UIEdgeInsetsAll(x) UIEdgeInsetsMake(x, x, x, x)
#define CGRectCenteredInRect(inner, outer) CGRectMake(outer.origin.x + ((outer.size.width - inner.size.width) / 2), outer.origin.y + ((outer.size.height - inner.size.height) / 2), inner.size.width, inner.size.height)
#define CGSizeSquare(x) (CGSizeMake(x, x))
#define LIMIT(minimum, value, maximum) (MIN(maximum, MAX(minimum, value)))
#define CGRectIsValid(rect) (!isnan(rect.origin.x) && !isnan(rect.origin.y) && !isnan(rect.size.width) && !isnan(rect.size.height))
#define CGSizeMax CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
#define PostNotification(Name, Object, UserInfo) [[NSNotificationCenter defaultCenter] postNotificationName:Name object:Object userInfo:UserInfo]
#define ObserveNotification(Observer, Selector, Notification, Object) [[NSNotificationCenter defaultCenter] addObserver:Observer selector:Selector name:Notification object:Object]
#define ObserveWithBlock(Notification, Object, block) [[NSNotificationCenter defaultCenter] addObserverForName:Notification object:Object queue:[NSOperationQueue mainQueue] usingBlock:block]
#define SelectorString(sel) NSStringFromSelector(@selector(sel))
#define DocumentDirectory (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject)

#define UnObserveNotification(Observer, Notification, Object) [[NSNotificationCenter defaultCenter] removeObserver:Observer name:Notification object:Object]
#define UnObserveAllNotifications(Observer) [[NSNotificationCenter defaultCenter] removeObserver:Observer]
#define MainBlock(block) dispatch_async(dispatch_get_main_queue(), \
        block \
    );
#define BackgroundBlock(block) dispatch_async(dispatch_get_global_queue((DISPATCH_QUEUE_PRIORITY_DEFAULT), 0), \
        block \
    );
#define InsetsValue(t, l, b, r) [NSValue valueWithUIEdgeInsets: UIEdgeInsetsMake(t, l, b, r)]
#define InsetsValueAll(x) [NSValue valueWithUIEdgeInsets: UIEdgeInsetsAll(x)]
#define IndexPath(section, row) [NSIndexPath indexPathForRow:row inSection:section]
#define DeviceIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)




typedef void (^VoidBlock) (void);
typedef void (^UIntBlock) (NSUInteger uInteger);
typedef void (^IntBlock) (NSInteger integer);
typedef void (^IDBlock) (id object);
typedef void (^StringBlock) (NSString *string);
typedef void (^NumberBlock) (NSNumber *number);
typedef void (^ArrayBlock) (NSArray *array);
typedef void (^BoolBlock) (BOOL boolValue);
typedef void (^FloatBlock) (CGFloat floatValue);
typedef void (^ErrorBlock) (NSError *error);
typedef void (^ProgressBlock) (CGFloat progress, NSString *title);


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