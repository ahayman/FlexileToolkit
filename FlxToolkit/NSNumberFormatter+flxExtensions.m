//
//  NSNumberFormatter+Extensions.m
//  iDB
//
//  Created by Aaron Hayman on 3/6/13.
//
//

#import "NSNumberFormatter+flxExtensions.h"

static const char sUnits[] = { '\0', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
static int sMaxUnits = sizeof sUnits - 1;


@implementation NSNumberFormatter (flxExtensions)
- (NSString *) fileSizeFromNumber:(NSNumber *)number{
    return [self fileSizeFromNumber:number useBase10:NO];
}
- (NSString *) fileSizeFromNumber:(NSNumber *)number useBase10:(BOOL)base10{
    int multiplier = base10 ? 1000 : 1024;
    int exponent = 0;
    
    double bytes = [number doubleValue];
    
    while ((bytes >= multiplier) && (exponent < sMaxUnits)) {
        bytes /= multiplier;
        exponent++;
    }
    
    return [NSString stringWithFormat:@"%@ %cB", [self stringFromNumber: [NSNumber numberWithDouble: bytes]], sUnits[exponent]];
}
@end
