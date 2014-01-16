//
//  FlxAlert.h
//  Flexile
//
//  Created by Aaron Hayman on 5/7/13.
//
//

#import <Foundation/Foundation.h>

typedef void (^AlertBlock)(NSUInteger);
typedef void (^YesNoBlock)(BOOL boolValue);

@interface FlxAlert : NSObject
@property (strong) NSString *title;
@property (strong) NSString *message;
@property (strong) NSString *cancelButton;
@property (strong) NSArray *buttons;
@property (copy) AlertBlock completionBlock;
+ (void) displayYesNoAlertWithTitle:(NSString *)title message:(NSString *)message completion:(YesNoBlock)completion;
+ (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message completion:(AlertBlock)completion;
+ (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (FlxAlert *) alertWithTitle:(NSString *)title message:(NSString *)message completion:(AlertBlock)completion;

- (void) display;
@end
