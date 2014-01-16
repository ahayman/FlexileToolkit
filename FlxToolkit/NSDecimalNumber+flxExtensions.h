//
//  NSDecimalNumberExtensions.h
//  iDB
//
//  Created by Aaron Hayman on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (flxExtensions)
- (BOOL) isNegative;
- (NSDecimalNumber *) decimalNumberByModulus:(NSDecimalNumber *)number;
- (NSDecimalNumber *) absoluteValue;
- (NSDecimalNumber *) floor;
- (NSDecimalNumber *) ceiling;
- (NSDecimalNumber *) roundToSignificantDigits:(NSUInteger)digits;
- (BOOL) isGreaterThanNumber:(NSDecimalNumber *)number;
- (BOOL) isLessThanNumber:(NSDecimalNumber *)number;
- (NSDecimalNumber *) squareRoot;
@end

@interface NSDecimalNumberHandler (extensions)
+ (NSDecimalNumberHandler *) decimalNumberHandlerWithRounding:(NSRoundingMode)mode scale:(short)scale;
@end