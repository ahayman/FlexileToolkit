//
//  UIFontExtensions.m
//  iDB
//
//  Created by Aaron Hayman on 9/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIFont+flxExtensions.h"

@implementation UIFont (flxExtensions)

- (NSString *) fontString{
    NSString *font = self.fontName;
    NSString *point = [NSNumber numberWithFloat:self.pointSize].stringValue;
    return [NSString stringWithFormat:@"%@:%@", font, point];
}

+ (UIFont *) UIFontForString:(NSString *)fontString{
    NSArray *comps = [fontString componentsSeparatedByString:@":"];
    if (comps.count < 2) return nil;
    NSString *font = [comps objectAtIndex:0];
    NSNumberFormatter *form = [[NSNumberFormatter alloc] init];
    form.locale = [NSLocale currentLocale];
    form.numberStyle = NSNumberFormatterDecimalStyle;
    CGFloat point = [[form numberFromString:[comps objectAtIndex:1]] floatValue];
    return [UIFont fontWithName:font size:point];
}

@end
