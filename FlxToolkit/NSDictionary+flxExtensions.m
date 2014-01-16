//
//  NSDictionary+ext.m
//  iDB
//
//  Created by Aaron Hayman on 7/25/12.
//
//

#import "NSDictionary+flxExtensions.h"

@implementation NSDictionary (flxExtensions)
- (id) objectForKeyedSubscript:(id)key{
    return [self objectForKey:key];
}
@end

@implementation NSMutableDictionary (flxExtensions)
- (void) setObject:(id)obj forKeyedSubscript:(id)key{
    if (obj){
        [self setObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}
@end
