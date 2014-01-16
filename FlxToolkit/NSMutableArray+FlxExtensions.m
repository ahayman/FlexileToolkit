//
//  NSMutableArrayExtension.m
//  iDB
//
//  Created by Aaron Hayman on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+FlxExtensions.h"

@implementation NSArray (flxExtensions)
+ (NSArray *) arrayWithArray:(NSArray *)array typeCheck:(Class)classType{
    return [NSMutableArray arrayWithArray:array typeCheck:classType];
}
- (id) firstObject{
    if (self.count > 0) return [self objectAtIndex:0];
    else return nil;
}
- (id) objectAtIndexedSubscript:(NSUInteger)index{
    if (self.count < 1) return nil;
    if (index == lastObj) index = self.count - 1;
    if (index >= self.count) return nil;
    return [self objectAtIndex:index];
}
- (NSUInteger) lastIndex{
    return (self.count > 0) ? self.count - 1 : 0;
}
- (id) objectForKeyedSubscript:(id)key{
    if ([key isKindOfClass:[NSString class]]){
        return [self valueForKeyPath:key];
    } else if ([key isKindOfClass:[NSNumber class]]){
        return self[[key integerValue]];
    } else {
        return nil;
    }
}
@end

@implementation NSMutableArray (flxExtensions)
+ (NSArray *) arrayWithArray:(NSArray *)array typeCheck:(Class)classType{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:array.count];
    for (id obj in array){
        if ([obj isKindOfClass:classType]) [mArray addObject:obj];
    }
    return mArray;
}
- (void)    moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    if (fromIndex == toIndex) return; 
    if (fromIndex >= self.count) return; 
    if (toIndex >= self.count) toIndex = self.count - 1; //toIndex too large, assume a move to end
    id movingObject = [self objectAtIndex:fromIndex];

    if (fromIndex < toIndex){
        for (int i = fromIndex; i <= toIndex; i++){
            [self replaceObjectAtIndex:i withObject:(i == toIndex) ? movingObject : [self objectAtIndex:i + 1]];
        }
    } else {
        id cObject = nil;
        id prevObject = nil;
        for (int i = toIndex; i <= fromIndex; i++){
            prevObject = cObject;
            cObject = [self objectAtIndex:i];
            [self replaceObjectAtIndex:i withObject:(i == toIndex) ? movingObject : prevObject];
        }
    }
}
- (void)    moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id object, NSUInteger from, NSUInteger to))block{
    if (fromIndex == toIndex) return;
    if (fromIndex >= self.count) return;
    if (toIndex >= self.count) toIndex = self.count - 1; //toIndex too large, assume a move to end
    id movingObject = [self objectAtIndex:fromIndex];
    id replacementObject;
    
    NSUInteger from;
    if (fromIndex < toIndex){
        for (int i = fromIndex; i <= toIndex; i++){
            from = (i == toIndex) ? fromIndex : (i + 1);
            replacementObject = (i == toIndex ? movingObject : [self objectAtIndex:from]);
            [self replaceObjectAtIndex:i withObject:replacementObject];
            if (block) block(replacementObject, from, i);
        }
    } else {
        id cObject = nil, prevObject;
        for (int i = toIndex; i <= fromIndex; i++){
            prevObject = cObject;
            cObject = [self objectAtIndex:i];
            replacementObject = (i == toIndex) ? movingObject : prevObject;
            from = (i == toIndex) ? fromIndex : (i - 1);
            [self replaceObjectAtIndex:i withObject:replacementObject];
            if (block) block(replacementObject, from, i);
        }
    }
}
- (void)    invertArray{
    NSUInteger operationCount = self.count / 2;
    NSUInteger lastIndex = self.count - 1;
    id tmpObject;
    for (int i = 0; i < operationCount; i++){
        tmpObject = [self objectAtIndex:i];
        [self replaceObjectAtIndex:i withObject:[self objectAtIndex:lastIndex - i]];
        [self replaceObjectAtIndex:lastIndex - i withObject:tmpObject];
    }
}
- (void)    invertArrayWithOperationBlock:(void(^)(id object, NSUInteger from, NSUInteger to))block{
    NSUInteger operationCount = self.count / 2;
    NSUInteger lastIndex = self.count - 1;
    id tmpObject1;
    id tmpObject2;
    for (int i = 0; i < operationCount; i++){
        tmpObject1 = [self objectAtIndex:i];
        tmpObject2 = [self objectAtIndex:lastIndex - i];
        [self replaceObjectAtIndex:i withObject:tmpObject2];
        [self replaceObjectAtIndex:lastIndex - i withObject:tmpObject1];
        if (block){
            block(tmpObject1, i, lastIndex - i);
            block(tmpObject2, lastIndex - i, i);
        }
    }
}
- (void) swap:(NSUInteger)index with:(NSUInteger)index2{
    FlxTry(index < self.count, @"Tried to swap from an index that's out of bounds.", NO, { return; })
    FlxTry(index2 < self.count, @"Tried to swap to an index that's out of bounds.", NO, { return; })
    id object = self[index2];
    [self replaceObjectAtIndex:index2 withObject:self[index]];
    [self replaceObjectAtIndex:index withObject:object];
}
- (void)    push:(id)object{
    if (object){
        [self insertObject:object atIndex:0];
    }
}
- (id)      pop{
    id object = self.firstObject;
    if (object) [self removeObjectAtIndex:0];
    return object;
}
- (id)      peek{
    return self.firstObject;
}
- (NSUInteger) append:(id)object{
    if ([object isKindOfClass:[NSArray class]]){
        if ([object count]){
            [self addObjectsFromArray:object];
            return self.count - 1;
        }
    } else if (object) {
        [self addObject:object];
        return self.count - 1;
    }
    return NSNotFound;
}
- (NSUInteger) insertObject:(id)object withComparator:(NSComparisonResult (^)(id object1, id object2))block{
    FlxAssert(object, @"NSMutableArray.insertObject:withComparator: insertion object cannot be nil");
    if (self.count < 1 || !block){ 
        [self addObject:object];
        return self.count - 1;
    }
    NSUInteger upper = self.count - 1;
    NSUInteger lower = 0;
    NSUInteger center;
    while (YES) {
        if (lower == upper) {
            if (block(object, [self objectAtIndex:lower]) == NSOrderedDescending) lower ++;
            [self insertObject:object atIndex:lower];
            return lower;
        }
        center = lower + ((upper - lower) / 2);
        switch (block(object, [self objectAtIndex:center])) {
            case NSOrderedAscending: upper = center; break;
            case NSOrderedDescending: lower = center + 1; break;
            case NSOrderedSame: [self insertObject:object atIndex:center]; return center;
        }
    }
}
- (NSUInteger) insertionIndexOfObject:(id)object withComparator:(NSComparisonResult (^)(id, id))block{
    
    FlxAssert(object, @"NSMutableArray.insertObject:withComparator: insertion object cannot be nil");
    if (self.count < 1 || !block){ 
        [self addObject:object];
        return self.count - 1;
    }
    NSUInteger upper = self.count - 1;
    NSUInteger lower = 0;
    NSUInteger center;
    while (YES) {
        if (lower == upper) {
            if (block(object, [self objectAtIndex:lower]) == NSOrderedDescending) lower ++;
            return lower;
        }
        center = lower + ((upper - lower) / 2);
        switch (block(object, [self objectAtIndex:center])) {
            case NSOrderedAscending: upper = center; break;
            case NSOrderedDescending: lower = center + 1; break;
            case NSOrderedSame: return center;
        }
    }
}
- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)index{
    if (index == lastObj) index = (self.count > 0) ? self.count - 1 : 0;
    if (index < self.count){
        if (obj)
            [self replaceObjectAtIndex:index withObject:obj];
        else
            [self removeObjectAtIndex:index];
    } else if (obj) {
        [self addObject:obj];
    }
}
- (void) addDistinctObjects:(NSArray *)objects{
    for (id object in objects){
        if (![self containsObject:object]) [self addObject:object];
    }
}
- (id) deepCopy{
    return [[NSMutableArray alloc] initWithArray:self copyItems:YES];
}
@end
