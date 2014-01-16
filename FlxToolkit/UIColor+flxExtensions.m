//
//  UIColorExtensions.m
//  iDB
//
//  Created by Aaron Hayman on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIColor+flxExtensions.h"
#import "FlxToolkitFunctions.h"
#import "NSString+flxExtensions.h"

@implementation UIColor (flxExtensions)

- (CGColorSpaceModel) colorSpaceModel{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *) colorSpaceString{
    switch (self.colorSpaceModel) {
		case kCGColorSpaceModelUnknown:
			return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome:
			return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB:
			return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK:
			return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab:
			return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN:
			return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed:
			return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern:
			return @"kCGColorSpaceModelPattern";
		default:
			return @"Not a valid color space";
	}
}

- (NSString *) colorString{
    if (self.colorSpaceModel == kCGColorSpaceModelRGB){
        return [NSString stringWithFormat:@"%f,%f,%f,%f", self.red, self.green, self.blue, self.alpha];
    } else if (self.colorSpaceModel == kCGColorSpaceModelMonochrome){
        return [NSString stringWithFormat:@"%f,%f", self.white, self.alpha];
    } else {
        FlxAssert(YES, @"Color space not supported");
    }
    return nil;
}
- (NSString *) hexString{
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    NSString *hexString = nil;
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    if (count == 4){
        CGFloat r = components[0];
        CGFloat g = components[1];
        CGFloat b = components[2];
        hexString = [NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    } else if (count == 2){
        CGFloat w = components[0];
        hexString = $(@"%02X%02X%02X", (int)(w * 255), (int)(w * 255), (int)(w * 255));
    }
    return hexString;
}
+ (UIColor *) UIColorFromColorString:(NSString *)string{
    NSMutableArray *comp = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@","]];
    UIColor *color;
    if (comp.count == 4){
        color = [UIColor colorWithRed:[[comp objectAtIndex:0] floatValue] green:[[comp objectAtIndex:1] floatValue] blue:[[comp objectAtIndex:2] floatValue] alpha:[[comp objectAtIndex:3] floatValue]];
    } else if (comp.count == 2){
        color = [UIColor colorWithWhite:[[comp objectAtIndex:0] floatValue] alpha:[[comp objectAtIndex:1] floatValue]];
    }
    return color;
}
+ (UIColor *) colorFromHexString:(NSString *)hexString{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (UIColor *) colorFromHexString:(NSString *)hexString overrideAlpha:(CGFloat)alpha{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+(UIColor *) colorWithRed:(CGFloat)red{
    return [UIColor colorWithRed:red green:0 blue:0 alpha:1];
}
+(UIColor *) colorWithGreen:(CGFloat)green{
    return [UIColor colorWithRed:0 green:green blue:0 alpha:1];
}
+(UIColor *) colorWithBlue:(CGFloat) blue{
    return [UIColor colorWithRed:0 green:0 blue:blue alpha:1];
}
+(UIColor *) colorWithYellow:(CGFloat)yellow{
    return [UIColor colorWithRed:yellow green:yellow blue:0 alpha:1];
}
+(UIColor *) colorWithAqua:(CGFloat)aqua{
    return [UIColor colorWithRed:0 green:aqua blue:aqua alpha:1];
}
+(UIColor *) colorWithPurple:(CGFloat)purple{
    return [UIColor colorWithRed:purple green:0 blue:purple alpha:1];
}
+(UIColor *) colorWithOrange:(CGFloat) orange{
    return [UIColor colorWithRed:orange green:orange * 0.4f blue:0 alpha:1];    
}
+(UIColor *) colorWithBurntOrange:(CGFloat)orange{
    return [UIColor colorWithRed:orange green:orange * 0.55f blue:0 alpha:1];
}
+(UIColor *) randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 );
    CGFloat brightness = ( arc4random() % 128 / 256.0 );
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (CGFloat) red{
    const CGFloat *colors = CGColorGetComponents(self.CGColor);
    return colors[0];
}

- (CGFloat) green{
    const CGFloat *colors = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return colors[0];
    return colors[1];
}

- (CGFloat) blue{
    const CGFloat *colors = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return colors[0];
    return colors[2];
}

- (CGFloat) white{
    const CGFloat *colors = CGColorGetComponents(self.CGColor);
    return colors[0];
}

- (CGFloat) alpha{
    return CGColorGetAlpha(self.CGColor);
}


@end
