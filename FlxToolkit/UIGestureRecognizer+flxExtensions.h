//
//  UIGestureRecognizer+ext.h
//  Flexile
//
//  Created by Aaron Hayman on 10/28/13.
//
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (flxExtensions)
- (BOOL) isGestureRecognizerInSiblings:(UIGestureRecognizer *)recognizer;
- (BOOL) isGestureRecognizerInSuperviewHierarchy:(UIGestureRecognizer *)recognizer;
@end
