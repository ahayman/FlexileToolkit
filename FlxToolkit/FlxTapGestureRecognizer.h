//
//  FlxTapGestureRecognizer.h
//  Flexile
//
//  Created by Aaron Hayman on 9/13/13.
//
//

#import <UIKit/UIKit.h>

@interface FlxTapGestureRecognizer : UIGestureRecognizer <UIGestureRecognizerDelegate>
@property (copy) void (^block)(void);
/**
 Number of touches required to recognize a tap.
 Default: 1.
 */
@property NSUInteger numberOfTouchesRequired;
/**
 Number of tops required to recognize
 Default: 1
 */
@property NSUInteger numberOfTapsRequired;
/**
 How much time is allowed for the gesture to recognize.  This is not only for multiple taps, but if you hold your finger down for longer than the timeTolerance, it will also fail.
 Default: 1.  Set to 0 for no time tolerance (as long as you wish).
 */
@property NSTimeInterval timeTolerance;
/**
 This is the tolerance the gesture will allow in movement of the finger before it fails.  If the value is 0, there is no tolerance.  Default: 0.
 @warning No matter what the positionTolerance is, the tap will fail if the finger moves outside of the gesture's view bounds.
 */
@property CGFloat positionTolerance;
/**
 Cooldown period represents the time period after an initial tap recognition (irregardless of the number of taps required) that any other recognitions will fail.  If this property is 0, then there is no cooldown.
 Default value for this propert is 0.
 */
@property NSTimeInterval cooldown;
/**
 Init with a block to be executed when the gesture is recognized.
 @param (void)(^VoidBlock)(void) block
 @returns instancetype
 @warning A side effect is that this class will add itself as a target.  If you remove this target, the block won't fire.  You can, of course, add more targets if you wish.
 */
- (instancetype) initWithBlock:(void (^)(void))block;
@end
