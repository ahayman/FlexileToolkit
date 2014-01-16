//
//  UIDragGestureRecognizer.h
//  iDB
//
//  Created by Aaron Hayman on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    DragDirectionNone = 0,
    DragDirectionUp = 1,
    DragDirectionDown = 2,
    DragDirectionLeft = 4,
    DragDirectionRight = 8,
    DragDirectionAll = 15
}DragDirection;

@interface FlxDragGestureRecognizer : UIGestureRecognizer <UIGestureRecognizerDelegate>
@property DragDirection dragDirection;
@property NSUInteger touchesRequired;
@property CGFloat tolerance; //Default: 5.0f
@property (readonly) CGSize dragVector;
@property (readonly) CGSize currentDragVector;
@property (readonly) DragDirection currentDirection;
@property (weak, readonly) id target;
@property (readonly) SEL action;
@property (readonly) CGFloat xVelocity;
@property (readonly) CGFloat yVelocity;
- (id) initWithDirection:(DragDirection)direction target:(id)target action:(SEL)action;
@end
