//
//  FlxTapGestureRecognizer.m
//  Flexile
//
//  Created by Aaron Hayman on 9/13/13.
//
//

#import "FlxTapGestureRecognizer.h"
#import "UIGestureRecognizer+flxExtensions.h"
#import "FlxToolkitFunctions.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define PositionTolerance 0
#define TimeTolerance 1.0f

@implementation FlxTapGestureRecognizer{
    CGPoint _initialPosition;
    NSTimeInterval _start;
    NSTimeInterval _cooldownstart;
    NSUInteger _taps;
}
#pragma mark - Init Methods
- (instancetype) init{
    return self = [self initWithTarget:self action:@selector(tap)];
}
- (instancetype) initWithBlock:(void (^)(void))block{
    if (self = [self initWithTarget:self action:@selector(tap)]){
        self.block = block;
    }
    return self;
}
- (instancetype) initWithTarget:(id)target action:(SEL)action{
    if (self = [super initWithTarget:target action:action]){
        _timeTolerance = TimeTolerance;
        _positionTolerance = PositionTolerance;
        _numberOfTapsRequired = 1;
        _numberOfTouchesRequired = 1;
        self.delegate = self;
    }
    return self;
}
#pragma mark - Private Methods
- (void) tap{
    if (_block) _block();
}
#pragma mark - Properties
- (CGPoint) avgPointForTouches:(NSSet *)touches{
    CGPoint avgPoint = CGPointMake(-1, -1);
    CGPoint curPoint;
    for (UITouch *touch in touches){
        if (avgPoint.x != -1){
            curPoint = [touch locationInView:self.view.window.rootViewController.view];
            avgPoint.x = (avgPoint.x + curPoint.x) / 2;
            avgPoint.y = (avgPoint.y + curPoint.y) / 2;
        } else {
            avgPoint = [touch locationInView:self.view.window.rootViewController.view];
        }
    }
    return avgPoint;
}
#pragma mark - Standard Methods
#pragma mark - Protocol Methods
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == self){
        if ([otherGestureRecognizer isMemberOfClass:self.class]){
            if ([self isGestureRecognizerInSuperviewHierarchy:otherGestureRecognizer]){
                return YES;
            } else if ([self isGestureRecognizerInSiblings:otherGestureRecognizer]){
                return YES;
            }
        }
    }
    return NO;
}
#pragma mark - Overridden Methods
- (void) resetVars{
    _taps = 0;
    _start = 0;
    _initialPosition = CGPointMake(0, 0);
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSTimeInterval current = [NSDate timeIntervalSinceReferenceDate];
    if (_cooldown > 0){
        if (_cooldownstart && current - _cooldownstart < _cooldown){
            self.state = UIGestureRecognizerStateFailed;
            return;
        }
    }
    if (touches.count == self.numberOfTouchesRequired){
        self.state = UIGestureRecognizerStatePossible;
        if (!_start || current - _start > _timeTolerance){
            _initialPosition = [self avgPointForTouches:event.allTouches];
            _start = [NSDate timeIntervalSinceReferenceDate];
            _taps = 1;
        } else {
            if (current - _start < _timeTolerance){
                _taps += 1;
            } else {
                _initialPosition = [self avgPointForTouches:event.allTouches];
                _taps = 1;
            }
            _start = current;
        }
    } else {
        self.state = UIGestureRecognizerStateFailed;
        [self resetVars];
    }
    FlxLog(@"Tap Begin: %lld", (long long)self);
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    FlxLog(@"Tap Moved: %f", [NSDate timeIntervalSinceReferenceDate]);
    CGPoint point = [self avgPointForTouches:event.allTouches];
    if (touches.count != self.numberOfTouchesRequired ||
        !CGRectContainsPoint(self.view.bounds, [self.view.window.rootViewController.view convertPoint:point toView:self.view]) ||
        (_positionTolerance > 0 && hypot(fabs(point.x - _initialPosition.x), fabs(point.y - _initialPosition.y)) > _positionTolerance) ||
        (_timeTolerance > 0 && [NSDate timeIntervalSinceReferenceDate] - _start > _timeTolerance))
    {
        self.state = UIGestureRecognizerStateFailed;
        [self resetVars];
    }
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    FlxLog(@"Tap: %lld Ended: %f", (long long)self, [NSDate timeIntervalSinceReferenceDate]);
    ExecuteBlockAfterDelay(.2, ^{
        FlxLog(@"---------------");
    });
    CGPoint point = [self avgPointForTouches:event.allTouches];
    if (touches.count != self.numberOfTouchesRequired ||
        !CGRectContainsPoint(self.view.bounds, [self.view.window.rootViewController.view convertPoint:point toView:self.view]) ||
        (_positionTolerance > 0 && hypot(fabs(point.x - _initialPosition.x), fabs(point.y - _initialPosition.y)) > _positionTolerance) ||
        (_timeTolerance > 0 && [NSDate timeIntervalSinceReferenceDate] - _start > _timeTolerance))
    {
        self.state = UIGestureRecognizerStateFailed;
        [self resetVars];
    } else {
        if (_taps == self.numberOfTapsRequired){
            self.state = UIGestureRecognizerStateRecognized;
            if (_cooldown > 0){
                _cooldownstart = [NSDate timeIntervalSinceReferenceDate];
            }
            [self resetVars];
        } else if (_taps > self.numberOfTapsRequired){
            self.state = UIGestureRecognizerStateFailed;
            [self resetVars];
        }
    }
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    FlxLog(@"Tap Cancelled: %f", [NSDate timeIntervalSinceReferenceDate]);
    self.state = UIGestureRecognizerStateCancelled;
    [self resetVars];
}
@end
