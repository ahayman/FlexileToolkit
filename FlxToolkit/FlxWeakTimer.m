//
//  WeakTimer.m
//  iDB
//
//  Created by Aaron Hayman on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlxWeakTimer.h"
#import "FlxToolkitFunctions.h"
#include <objc/message.h>

@implementation FlxWeakTimer{
    NSTimer *_timer;
    id __weak _target;
    SEL _action;
    BOOL _repeat;
    NSTimeInterval _interval;
    id _userInfo;
}
@synthesize target=_target, action=_action, userInfo=_userInfo;
#pragma mark - 
#pragma mark Init Methods
- (id) init{
    return [self initWithTarget:nil action:nil interval:0 repeat:NO];
}
- (id) initWithTarget:(__weak id)target action:(SEL)action interval:(NSTimeInterval)interval repeat:(BOOL)repeat{
    if (self = [super init]){
        _target = target;
        _action = action;
        _interval = interval;
        _repeat = repeat;
    }
    return self;
}
#pragma mark - 
#pragma mark Private Methods

#pragma mark -
#pragma mark Protocol Methods

#pragma mark - 
#pragma mark Properties
- (void) setRepeat:(BOOL)repeat{
    if (_repeat != repeat){
        _repeat = repeat;
        if (_timer && _target && _action){
            [_timer invalidate];
            _timer = nil;
            _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(fire) userInfo:nil repeats:_repeat];
        }
    }
}
- (BOOL) repeat{
    return _repeat;
}
- (void) setInterval:(NSTimeInterval)interval{
    if (_interval != interval){
        _interval = interval;
        if (_timer && _target && _action){
            [_timer invalidate];
            _timer = nil;
            _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(fire) userInfo:nil repeats:_repeat];            
        }
    }
}
- (NSTimeInterval) interval{
    return _interval;
}
- (BOOL) active{
    if (_timer) return YES;
    else return NO;
}
#pragma mark -
#pragma mark Standard Method

- (void) fire{
    if ((!_target || !_action) && _timer){
        FlxLog(@"WeakTimer.fire: Target not found, invalidating timer");
        [_timer invalidate];
        _timer = nil;
    } else if (_timer) {
        if (_userInfo) objc_msgSend(_target, _action, _userInfo);
        else objc_msgSend(_target, _action);
    }
}
- (void) fireAfterDelay:(NSTimeInterval)delay{
    if (_target && _action) [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(fire) userInfo:nil repeats:NO];
}
- (void) stop{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
}
- (void) start{
    if (!_timer && _target && _action) 
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(fire) userInfo:nil repeats:_repeat];
    else if (_timer && _target && _action) {
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(fire) userInfo:nil repeats:_repeat];
    }
}
- (void) restart{
    [self stop];
    [self start];
}
#pragma mark - 
#pragma mark Overridden Methods

@end
