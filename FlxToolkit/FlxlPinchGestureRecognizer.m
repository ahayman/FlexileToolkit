//
//  FlxlPinchGestureRecognizer.m
//  iDB
//
//  Created by Aaron Hayman on 9/16/12.
//
//

#import "FlxlPinchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FlxlPinchGestureRecognizer{
    NSUInteger _totalTouchCount;
}
#pragma mark -
#pragma mark Init Methods

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Protocol Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Standard Methods

#pragma mark -
#pragma mark Overridden Methods
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.state != UIGestureRecognizerStateFailed)
        _totalTouchCount = event.allTouches.count;
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    _totalTouchCount = event.allTouches.count;
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    _totalTouchCount = event.allTouches.count;
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    _totalTouchCount = event.allTouches.count;
}

@end
