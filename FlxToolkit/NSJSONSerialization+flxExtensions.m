//
//  NSJSONSerialization+extensions.m
//  Flexile
//
//  Created by Aaron Hayman on 7/30/13.
//
//

#import "NSJSONSerialization+flxExtensions.h"

@implementation NSJSONSerialization (flxExtensions)
+ (id) JSONObjectFromString:(NSString *)string{
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}
+ (NSString *) JSONStringFromObject:(id)object{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:object options:0 error:nil] encoding:NSUTF8StringEncoding];
}
@end
