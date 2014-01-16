//
//  NSObject+ext.m
//  iDB
//
//  Created by Aaron Hayman on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+flxExtensions.h"
#include <objc/runtime.h>

@implementation NSObject (flxExtensions)
+ (BOOL) object:(id)object1 equalTo:(id)object2{
    if (!object1 && !object2) return YES;
    if ((!object1 && object2) || (object1 && !object2)) return NO;
    if (![object2 isKindOfClass:[object1 class]]) return NO;
    if (object1 && [object1 respondsToSelector:@selector(isEqual:)])
        return [object1 isEqual:object2];
    if (object2 && [object2 respondsToSelector:@selector(isEqual:)])
        return [object2 isEqual:object1];
    return object1 == object2;
}
- (NSMutableDictionary *) associatedInfo{
    static void * const associated_key = (void *)&associated_key;
    NSMutableDictionary *info = objc_getAssociatedObject(self, associated_key);
    if (!info){
        info = [NSMutableDictionary new];
        objc_setAssociatedObject(self, associated_key, info, OBJC_ASSOCIATION_RETAIN);
    }
    return info;
}
@end
