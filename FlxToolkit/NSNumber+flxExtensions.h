//
//  NSNumberExtension.h
//  iDB
//
//  Created by Aaron Hayman on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (flxExtensions)
- (BOOL) isLessThanNumber:(NSNumber *)number;
- (BOOL) isGreaterThanNumber:(NSNumber *)number;
- (BOOL) isLessThanEqualToNumber:(NSNumber *)number;
- (BOOL) isGreaterThanEqualToNumber:(NSNumber *)number;
+ (BOOL) number:(NSNumber *)number1 isEqualToNumber:(NSNumber *)number2;
@end
