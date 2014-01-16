//
//  UIGestureRecognizer+ext.m
//  Flexile
//
//  Created by Aaron Hayman on 10/28/13.
//
//

#import "UIGestureRecognizer+flxExtensions.h"

@implementation UIGestureRecognizer (flxExtensions)
- (BOOL) isGestureRecognizerInSiblings:(UIGestureRecognizer *)recognizer{
    UIView *superview = self.view.superview;
    NSUInteger index = [superview.subviews indexOfObject:self.view];
    if (index != NSNotFound){
        for (int i = 0; i < index; i++){
            UIView *sibling = superview.subviews[i];
            for (UIGestureRecognizer *viewRecognizer in sibling.gestureRecognizers){
                if (recognizer == viewRecognizer){
                    return YES;
                }
            }
        }
    }
    return NO;
}
- (BOOL) isGestureRecognizerInSuperviewHierarchy:(UIGestureRecognizer *)recognizer{
    if (!recognizer) return NO;
    if (!self.view) return NO;
    //Check siblings
    UIView *superview = self.view;
    while (YES) {
        superview = superview.superview;
        if (!superview) return NO;
        for (UIGestureRecognizer *viewRecognizer in superview.gestureRecognizers){
            if (recognizer == viewRecognizer){
                return YES;
            }
        }
    }
}
@end
