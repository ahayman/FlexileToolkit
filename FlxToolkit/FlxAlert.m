//
//  FlxAlert.m
//  Flexile
//
//  Created by Aaron Hayman on 5/7/13.
//
//

#import "FlxAlert.h"
#import "FlxToolkitExtensions.h"
#import "FlxToolkitDefines.h"
#import <UIKit/UIKit.h>

@interface FlxAlert () <UIAlertViewDelegate>

@end

@implementation FlxAlert{
    id _lock;
    UIAlertView *_alert;
}
#pragma mark - Init Methods
+ (void) displayYesNoAlertWithTitle:(NSString *)title message:(NSString *)message completion:(YesNoBlock)completion{
    FlxAlert *alert = [FlxAlert alertWithTitle:title message:message completion:!completion ? nil : ^(NSUInteger uInteger) {
        if (uInteger == 0){
            completion(YES);
        } else {
            completion(NO);
        }
    }];
    alert.cancelButton = nil;
    alert.buttons = Array(@"Yes", @"No");
    [alert display];
}
+ (void) displayAlertTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons completion:(AlertBlock)completion{
    FlxAlert *alert = [FlxAlert alertWithTitle:title message:message completion:completion];
    alert.cancelButton = buttons.firstObject ? : @"OK";
    if (buttons.count > 1){
        alert.buttons = ({
            NSMutableArray *otherButtons = [NSMutableArray new];
            for (int i = 1; i < buttons.count; i++){
                [otherButtons addObject:buttons[i]];
            }
            otherButtons;
        });
    }
    [alert display];
}
+ (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message completion:(AlertBlock)completion{
    [[FlxAlert alertWithTitle:title message:message completion:completion] display];
}
+ (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message{
    [[FlxAlert alertWithTitle:title message:message completion:nil] display];
}
+ (FlxAlert *) alertWithTitle:(NSString *)title message:(NSString *)message completion:(AlertBlock)completion{
    FlxAlert *alert = [FlxAlert new];
    alert.title = title;
    alert.message = message;
    alert.cancelButton = @"OK";
    alert.completionBlock = completion;
    return alert;
}
#pragma mark - Private Methods

#pragma mark - Properties

#pragma mark - Standard Methods
- (void) display{
    if (!_alert){
        MainBlock(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title message:_message delegate:_completionBlock ? self : nil cancelButtonTitle:_cancelButton otherButtonTitles:nil];
            for (NSString *string in _buttons){
                [alert addButtonWithTitle:string];
            }
            if (_completionBlock){
                _alert = alert;
                _lock = Array(self);
            }
            [alert show];
        })
    }
}
#pragma mark - Protocol Methods
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_completionBlock){
        _completionBlock(buttonIndex);
    }
    _completionBlock = nil;
    _alert = nil;
    _lock = nil;
}
#pragma mark - Overridden Methods
@end
