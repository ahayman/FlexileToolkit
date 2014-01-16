//
//  NSDecimalNumberExtensions.m
//  iDB
//
//  Created by Aaron Hayman on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDecimalNumber+flxExtensions.h"

@implementation NSDecimalNumber (flxExtensions)
- (BOOL) isNegative{
    if ([self compare:[NSDecimalNumber zero]] == NSOrderedAscending) return YES;
    return NO;
}
- (NSDecimalNumber *) decimalNumberByModulus:(NSDecimalNumber *)number{
    if ([number isEqualToNumber:[NSDecimalNumber zero]]) return self;
    NSDecimalNumber *number1 = self.absoluteValue;
    number = number.absoluteValue;
    if ([self isLessThanNumber:number]) return self;
    NSDecimalNumber *floor = [number1 decimalNumberByDividingBy:number withBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRounding:NSRoundDown scale:0]];
    floor = [floor decimalNumberByMultiplyingBy:number];
    return [self decimalNumberBySubtracting:floor];
}
- (NSDecimalNumber *) absoluteValue{
    if (self.isNegative) return [self decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES]];
    else return self;
}
- (NSDecimalNumber *) floor{
    return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRounding:NSRoundDown scale:0]];
}
- (NSDecimalNumber *) ceiling{
    return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRounding:NSRoundUp scale:0]];
}
- (NSDecimalNumber *) roundToSignificantDigits:(NSUInteger)digits{
    return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decimalNumberHandlerWithRounding:NSRoundPlain scale:digits]];
}
- (BOOL) isGreaterThanNumber:(NSDecimalNumber *)number{
    if ([self compare:number] == NSOrderedDescending) return YES;
    return NO;
}
- (BOOL) isLessThanNumber:(NSDecimalNumber *)number{
    if ([self compare:number] == NSOrderedAscending) return YES;
    return NO;
}
- (NSDecimalNumber *) squareRoot{
    float floatRep = self.absoluteValue.floatValue;
    floatRep = sqrtf(floatRep);
    return [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:floatRep] decimalValue]];
    
    /*NSInteger result = 0;
    
    NSInteger __block streamCount = 0;
    NSInteger (^Stream)(void) = ^NSInteger{
        if (streamCount >= stringRep.length) return 0;
        else 
            return [[stringRep substringWithRange:NSMakeRange(streamCount, 1)] integerValue];
    };

    do {
        <#statements#>
    } while (<#condition#>);
 */   
}
@end

@implementation NSDecimalNumberHandler (extensions)
 + (NSDecimalNumberHandler *) decimalNumberHandlerWithRounding:(NSRoundingMode)mode scale:(short)scale{
     return [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
 }
@end