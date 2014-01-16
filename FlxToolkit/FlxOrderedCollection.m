//
//  FlxOrderedCollection.m
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import "FlxOrderedCollection.h"
#import "FlxCollection.h"

@implementation FlxOrderedCollection{
    FlxCollection *_collection;
    NSMutableArray *_objects;
}
#pragma mark - Class Methods
#pragma mark - Init Methods
+ (instancetype) collectionWithKeyPaths:(NSArray *)keyPaths{
    return [[FlxOrderedCollection alloc] initWithKeyPaths:keyPaths];
}
- (instancetype) initWithKeyPaths:(NSArray *)keyPaths{
    if (!keyPaths.count) return nil;
    if (self = [super init]){
        _collection = [FlxCollection collectionWithKeyPaths:keyPaths];
        _objects = [NSMutableArray new];
    }
    return self;
}
#pragma mark - Private Methods
#pragma mark - Properties
- (NSUInteger) count{
    return _objects.count;
}
- (id) firstObject{
    return _objects.firstObject;
}
- (id) lastObject{
    return _objects.lastObject;
}
- (NSUInteger) lastIndex{
    return _objects.lastIndex;
}
#pragma mark - Standard Methods
- (BOOL) containsObject:(id)object{
    return [_objects containsObject:object];
}
- (id) objectForKey:(id)key usingKeyPath:(NSString *)keyPath{
    return [_collection objectForKey:key usingKeyPath:keyPath];
}
- (id) objectForKey:(id)key{
    return [_collection objectForKey:key];
}
- (NSArray *) objectsForKey:(id)key usingKeyPath:(NSString *)keyPath{
    return [_collection objectsForKey:key usingKeyPath:keyPath];
}
- (NSArray *) objectsForKey:(id)key{
    return [_collection objectsForKey:key];
}
- (id) objectAtIndex:(NSUInteger)index{
    return _objects[index];
}
- (NSUInteger) indexOfObject:(id)object{
    return [_objects indexOfObject:object];
}
- (void) addObject:(id)object{
    if (!object)return;
    [_objects addObject:object];
    [_collection addObject:object];
}
- (void) addObjects:(NSArray *)objects{
    if (!objects)return;
    [_objects append:objects];
    [_collection addObjects:objects];
}
- (void) insertObject:(id)object atIndex:(NSUInteger)index{
    if (!object)return;
    [_objects insertObject:object atIndex:index];
}
- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)object{
    if (!object) return;
    id oldObject = _objects[index];
    [_objects replaceObjectAtIndex:index withObject:object];
    [_collection removeObject:oldObject];
    [_collection addObject:object];
}
- (void) removeObject:(id)object{
    [_objects removeObject:object];
    [_collection removeObject:object];
}
- (void) removeObjectForKey:(id)key usingKeyPath:(NSString *)keyPath{
    id object = [_collection objectForKey:key usingKeyPath:keyPath];
    if (!object) return;
    [_objects removeObject:object];
    [_collection removeObject:object];
}
- (void) removeObjectAtIndex:(NSUInteger)index{
    id object = _objects[index];
    if (!object) return;
    _objects[index] = nil;
    [_collection removeObject:object];
}
- (void) removeAllObjects{
    [_objects removeAllObjects];
    [_collection removeAllObjects];
}
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    [_objects moveObjectAtIndex:fromIndex toIndex:toIndex];
}
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id, NSUInteger, NSUInteger))block{
    [_objects moveObjectAtIndex:fromIndex toIndex:toIndex withBlock:block];
}
- (void) swap:(NSUInteger)index with:(NSUInteger)index2{
    [_objects swap:index with:index2];
}
#pragma mark - Protocol Method
- (id) objectForKeyedSubscript:(id)key{
    return [_collection objectForKeyedSubscript:key];
}
- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)index{
    [self replaceObjectAtIndex:index withObject:obj];
}
- (id) objectAtIndexedSubscript:(NSUInteger)index{
    return _objects[index];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len{
    return [_objects countByEnumeratingWithState:state objects:buffer count:len];
}
#pragma mark - Overridden Methods
@end
