//
//  UIDragGestureRecognizer.m
//  iDB
//
//  Created by Aaron Hayman on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlxDragGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FlxDragGestureRecognizer{
    DragDirection _direction;
    NSUInteger _touchesRequired;
    CGPoint _beginningPoint;
    CGPoint _currentPoint;
    CGPoint _prevPoint;
    CGFloat _tolerance;
    DragDirection _currentDirection;
    NSTimeInterval _lastTime;
    CGFloat _xVelocity;
    CGFloat _yVelocity;
    __weak id _target;
    SEL _action;
}
#pragma mark - 
#pragma mark Init Methods
@synthesize dragDirection=_direction, touchesRequired=_touchesRequired, tolerance=_tolerance, currentDirection=_currentDirection;
- (id) init{
    return [self initWithDirection:0 target:nil action:nil];
 }
- (id) initWithTarget:(id)target action:(SEL)action{
    return [self initWithDirection:0 target:target action:action];
}
- (id) initWithDirection:(DragDirection)direction target:(id)target action:(SEL)action{
    if (self = [super initWithTarget:target action:action]){
        self.dragDirection = direction;
        _touchesRequired = 1;
        _tolerance = 5;
        _currentDirection = DragDirectionNone;
        _target = target;
        _action = action;
        self.delegate = self;
    }
    return self;
}
#pragma mark - 
#pragma mark Private Methods
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
#pragma mark -
#pragma mark Protocol Methods
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
#pragma mark - 
#pragma mark Properties
- (CGSize) dragVector{
    return CGSizeMake(_beginningPoint.x - _currentPoint.x, _beginningPoint.y - _currentPoint.y);
}
- (CGSize) currentDragVector{
    return CGSizeMake(_prevPoint.x - _currentPoint.x, _prevPoint.y - _currentPoint.y);
}

#pragma mark -
#pragma mark Standard Methods

#pragma mark - 
#pragma mark Overridden Methods
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_direction == 0) self.state = UIGestureRecognizerStateFailed;
    if (event.allTouches.count > _touchesRequired){ 
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    _beginningPoint = _currentPoint = [self avgPointForTouches:touches];
    _lastTime = [NSDate timeIntervalSinceReferenceDate];
    _xVelocity = _yVelocity = 0;
    self.state = UIGestureRecognizerStatePossible;
    
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    _prevPoint = _currentPoint;
    _currentPoint =  [self avgPointForTouches:touches];
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - _lastTime;
    _lastTime = currentTime;
    _xVelocity = ((_xVelocity + (_currentPoint.x - _prevPoint.x) / ((elapsed ? : 1.0f))) / 2);
    _yVelocity = ((_yVelocity + (_currentPoint.y - _prevPoint.y) / ((elapsed ? : 1.0f))) / 2);
    if (self.state == UIGestureRecognizerStateBegan){
        self.state = UIGestureRecognizerStateChanged;
        return;
    } else if (self.state == UIGestureRecognizerStateChanged){
        return;
    }
    if (touches.count == _touchesRequired && self.state == UIGestureRecognizerStatePossible){
        CGFloat verticleVector = _beginningPoint.y - _currentPoint.y;
        CGFloat horizontalVecor = _beginningPoint.x - _currentPoint.x;
        
        CGFloat (^VectorForType)(DragDirection) = ^CGFloat (DragDirection direction){
            CGFloat returnVector = 0;
            switch (direction) {
                case DragDirectionUp:
                    returnVector = verticleVector; break;
                case DragDirectionDown:
                    returnVector = verticleVector * -1; break;
                case  DragDirectionLeft:
                    returnVector = horizontalVecor; break;
                case DragDirectionRight:
                    returnVector = horizontalVecor * -1; break;
                case DragDirectionAll:
                    returnVector = (fabs(verticleVector) > fabs(horizontalVecor)) ? fabs(verticleVector) : fabs(horizontalVecor); break;
                case DragDirectionNone:
                    break;
            }
            return returnVector;
        };
        
        //Find the greatest allowed/disallowed Vectors
        CGFloat currentVector;
        CGFloat greatestAllowedVector = 0;
        CGFloat greatestDisallowedVector = 0;
        for (int i = 1; i <=8; i *= 2){
            _currentDirection = i & _direction;
            currentVector = VectorForType(i);
            if (_currentDirection == 0 && currentVector > greatestDisallowedVector)
                greatestDisallowedVector = currentVector;
            else if (currentVector > greatestAllowedVector)
                greatestAllowedVector = currentVector;
        }
        
        if (greatestAllowedVector > _tolerance){
            if (greatestDisallowedVector > greatestAllowedVector) self.state = UIGestureRecognizerStateFailed;
            else 
                self.state = UIGestureRecognizerStateBegan;
        } else if (greatestDisallowedVector > _tolerance) 
            self.state = UIGestureRecognizerStateFailed;
        
    } else 
        self.state = UIGestureRecognizerStateFailed;
    
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (event.allTouches.count - touches.count == 0){
        _currentDirection = DragDirectionNone;
        _beginningPoint = CGPointMake(-1, -1);
        self.state = (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) ? UIGestureRecognizerStateEnded : UIGestureRecognizerStateFailed;
    }
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    _currentDirection = DragDirectionNone;
    _beginningPoint = CGPointMake(-1, -1);
    self.state = UIGestureRecognizerStateFailed;
}
@end
