//
//  NSString+extensions.h
//  iDB
//
//  Created by Aaron Hayman on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define $(...)        [NSString  stringWithFormat:__VA_ARGS__,nil]

@interface NSString (flxExtensions)
+ (BOOL) string:(NSString *)string1 isEqualToString:(NSString *)string2;
/**
 Generates a New Globally Unique 36 Character (hyphenated) Identifier as a NSString
 **/
+ (NSString *) newGUID;
+ (NSString *) randomStringLength:(int)len;
- (NSString *) stringBySeparatingWords;
- (NSString *) repeat:(NSUInteger)repeat;
- (NSString *) urlSafeString;
- (NSString *) encodedURLString;
- (BOOL) containsString:(NSString *)string;
@end
