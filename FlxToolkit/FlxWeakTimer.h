//
//  WeakTimer.h
//  iDB
//
//  Created by Aaron Hayman on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlxWeakTimer : NSObject
@property (weak) id target;
@property SEL action;
@property BOOL repeat;
@property NSTimeInterval interval;
@property (strong) id userInfo;
@property (readonly) BOOL active;

- (id) initWithTarget:(__weak id)target action:(SEL)action interval:(NSTimeInterval)interval repeat:(BOOL)repeat;
- (void) fire;
- (void) fireAfterDelay:(NSTimeInterval)delay;
- (void) stop;
- (void) start;
- (void) restart;
@end
