//
//  NSString+extensions.m
//  iDB
//
//  Created by Aaron Hayman on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+flxExtensions.h"

#define LettersForGeneration @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "

@implementation NSString (flxExtensions)
+ (BOOL) string:(NSString *)string1 isEqualToString:(NSString *)string2{
    if (!string1.length && !string2.length) return YES;
    else if (!string1.length && string2.length) return NO;
    else if (string1.length && !string2.length) return NO;
    else if ([string1 isEqual:string2]) return YES;
    else return NO;
}
+ (NSString *) newGUID{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}
+ (NSString *) randomStringLength:(int)len{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [LettersForGeneration characterAtIndex: arc4random() % [LettersForGeneration length]]];
    }
    
    return randomString;
}
- (NSString *) stringBySeparatingWords{
    BOOL lastUpper = YES;
    NSCharacterSet *uppers = [NSCharacterSet uppercaseLetterCharacterSet];
    NSMutableString *new = [NSMutableString stringWithCapacity:self.length * 2];
    for (int i = 0; i < self.length; i++){
        unichar c = [self characterAtIndex:i];
        if ([uppers characterIsMember:c]){
            if (!lastUpper){
                [new appendString:@" "];
            }
            lastUpper = YES;
        } else {
            lastUpper = NO;
        }
        [new appendFormat:@"%c", c];
    }
    return new;
}
- (NSString *) repeat:(NSUInteger)repeat{
    return [@"" stringByPaddingToLength:repeat * [self length] withString:self startingAtIndex:0];
}
- (NSString *) urlSafeString{
    //We first encode the string in case it already had escaped characters
    NSString *encoded = self.encodedURLString;
    //Add escapes
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                     (CFStringRef)encoded,
                                                                     NULL,
                                                                     NULL,
                                                                     kCFStringEncodingUTF8);
}
- (NSString *) encodedURLString{
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                  (CFStringRef)self,
                                                                                                  CFSTR(""),
                                                                                                  kCFStringEncodingUTF8);
}
- (BOOL) has:(NSString *)string{
    return ([self rangeOfString:string].location != NSNotFound);
}
- (CGSize) sizeWithUIFont:(UIFont *)font{
  if (font){
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
  }
  return CGSizeZero;
}
- (CGSize) sizeWithUIFont:(UIFont *)font constrainedToSize:(CGSize)size{
  if (font){
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
  }
  return size;
}
@end
