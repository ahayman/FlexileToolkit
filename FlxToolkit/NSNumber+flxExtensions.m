//
//  NSNumberExtension.m
//  iDB
//
//  Created by Aaron Hayman on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+flxExtensions.h"

@implementation NSNumber (flxExtensions)
- (BOOL) isLessThanNumber:(NSNumber *)number{
    return ([self compare:number] == NSOrderedAscending);
}
- (BOOL) isGreaterThanNumber:(NSNumber *)number{
    return ([self compare:number] == NSOrderedDescending);
}
- (BOOL) isLessThanEqualToNumber:(NSNumber *)number{
    NSComparisonResult result = [self compare:number];
    return (result == NSOrderedAscending || result == NSOrderedSame);
}
- (BOOL) isGreaterThanEqualToNumber:(NSNumber *)number{
    NSComparisonResult result = [self compare:number];
    return (result == NSOrderedDescending || result == NSOrderedSame);
}
+ (BOOL) number:(NSNumber *)number1 isEqualToNumber:(NSNumber *)number2{
    if (!number1 && !number2) return YES;
    else if (!number1 && number2) return NO;
    else if (number1 && !number2) return NO;
    else if (![number1 isKindOfClass:[NSNumber class]] || ![number2 isKindOfClass:[NSNumber class]]) return NO;
    else if ([number1 isEqualToNumber:number2]) return YES;
    else return NO;
}
@end
