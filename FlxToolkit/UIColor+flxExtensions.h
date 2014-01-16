//
//  UIColorExtensions.h
//  iDB
//
//  Created by Aaron Hayman on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Color(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define WColor(w, a) [UIColor colorWithWhite:w alpha:a]
#define PColor(imageName) [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]
#define HColor(h, s, b, a) [UIColor colorWithHue:h saturation:s brightness:b alpha:a]
#define HexColor(x) [UIColor colorFromHexString:x]

@interface UIColor (flxExtensions)

- (CGColorSpaceModel) colorSpaceModel;
- (NSString *) colorSpaceString;
- (NSString *) colorString;
- (NSString *) hexString;

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (UIColor *) colorFromHexString:(NSString *)hexString overrideAlpha:(CGFloat)alpha;
+ (UIColor *) UIColorFromColorString:(NSString *)string;
+ (UIColor *) colorWithRed:(CGFloat)red;
+ (UIColor *) colorWithGreen:(CGFloat)green;
+ (UIColor *) colorWithBlue:(CGFloat) blue;
+ (UIColor *) colorWithYellow:(CGFloat)yellow;
+ (UIColor *) colorWithAqua:(CGFloat)aqua;
+ (UIColor *) colorWithPurple:(CGFloat)purple;
+ (UIColor *) colorWithOrange:(CGFloat) orange;
+ (UIColor *) colorWithBurntOrange:(CGFloat)orange;
+ (UIColor *) randomColor;
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) white;
- (CGFloat) alpha;

@end
