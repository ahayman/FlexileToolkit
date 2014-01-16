//
//  NSNumberFormatter+Extensions.h
//  iDB
//
//  Created by Aaron Hayman on 3/6/13.
//
//

#import <Foundation/Foundation.h>

@interface NSNumberFormatter (flxExtensions)
- (NSString *) fileSizeFromNumber:(NSNumber *)number;
- (NSString *) fileSizeFromNumber:(NSNumber *)number useBase10:(BOOL)base10;
@end
