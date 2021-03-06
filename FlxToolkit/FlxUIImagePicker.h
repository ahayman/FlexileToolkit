//
//  FlxUIImagePicker.h
//  Flexile
//
//  Created by Aaron Hayman on 12/12/13.
//
//

#import <UIKit/UIKit.h>

@interface FlxUIImagePicker : NSObject
+ (void) pickfromImageLibraryFromView:(UIView *)presentingView onSelection:(void (^)(UIImage *image))selectionBlock;
+ (void) pickfromCameraFromView:(UIView *)presentingView onSelection:(void (^)(UIImage *image))selectionBlock;
@end
