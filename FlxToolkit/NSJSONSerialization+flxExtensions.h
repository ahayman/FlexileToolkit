//
//  NSJSONSerialization+extensions.h
//  Flexile
//
//  Created by Aaron Hayman on 7/30/13.
//
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (flxExtensions)
+ (id) JSONObjectFromString:(NSString *)string;
+ (NSString *) JSONStringFromObject:(id)object;
@end
