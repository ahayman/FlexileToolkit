//
//  NSObject+ext.m
//  iDB
//
//  Created by Aaron Hayman on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+flxExtensions.h"
#include <objc/runtime.h>

#define FlxNeedToPerformKey @"FlxNeedsToPerformSelectorKey"
#define FlxConsolidatedPerformKey @"FlxConsolidatedPerformKey"

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
- (void) performSelectorOnceOnMain:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay{
    NSMutableDictionary *associatedInfo = self.associatedInfo;
    NSMutableDictionary *selectors = associatedInfo[FlxNeedToPerformKey];
    if (!selectors){
        selectors = [NSMutableDictionary new];
        associatedInfo[FlxNeedToPerformKey] = selectors;
    }
    NSString *selectorString = NSStringFromSelector(selector);
    id selectorObject = selectors[selectorString];
    if (!selectorObject){
        [self performSelector:@selector(_flxPerformSelector:) withObject:selectorString afterDelay:delay inModes:@[NSRunLoopCommonModes]];
        selectors[selectorString] = object ? : [NSNull null];
    }
}
- (void) _flxPerformSelector:(NSString *)selectorString{
    SEL selector = NSSelectorFromString(selectorString);
    NSMutableDictionary *selectors = self.associatedInfo[FlxNeedToPerformKey];
    id object = selectors[selectorString];
    selectors[selectorString] = nil;
    [self performSelectorOnMainThread:selector withObject:(object != [NSNull null]) ? object : nil waitUntilDone:NO];
}
- (void) performSelectorOnceAfterDelay:(SEL)selector{
    NSMutableArray *selectors = self.associatedInfo[FlxConsolidatedPerformKey];
    if (!selectors){
        selectors = [NSMutableArray new];
        self.associatedInfo[FlxConsolidatedPerformKey] = selectors;
        [self performSelector:@selector(_flxConsolidatedSelectorPerform) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
    }
    [selectors addObject:NSStringFromSelector(selector)];
}
- (void) _flxConsolidatedSelectorPerform{
    NSMutableArray *selectors = self.associatedInfo[FlxConsolidatedPerformKey];
    self.associatedInfo[FlxConsolidatedPerformKey] = nil;
    for (NSString *selectorString in selectors){
        [self performSelectorOnMainThread:NSSelectorFromString(selectorString) withObject:nil waitUntilDone:NO];
    }
}
@end
