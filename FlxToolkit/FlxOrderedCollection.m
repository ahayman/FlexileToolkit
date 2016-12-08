//
//  FlxOrderedCollection.m
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import "FlxOrderedCollection.h"
#import "FlxToolkitExtensions.h"

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
        NSArray *objectArray = _objects;
        FlxCollectionComparator comparator = ^NSComparisonResult (id obj1, id obj2){
            NSUInteger idx1 = [objectArray indexOfObject:obj1];
            NSUInteger idx2 = [objectArray indexOfObject:obj2];
            return (idx1 < idx2) ? NSOrderedAscending : (idx1 > idx2) ? NSOrderedDescending : NSOrderedSame;
        };
        for (NSString *keyPath in keyPaths){
            [_collection setOrderComparator:comparator forKeyPath:keyPath];
        }
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
  	if (index >= _objects.count) return nil;
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
  [_collection addObject:object];
}
- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)object{
    if (!object) return;
  	if (index >= _objects.count) return;
    id oldObject = _objects[index];
    [_objects replaceObjectAtIndex:index withObject:object];
    [_collection removeObject:oldObject];
    [_collection addObject:object];
}
- (void) removeObject:(id)object{
    [_objects removeObject:object];
    [_collection removeObject:object];
}
- (void) removeObjects:(NSArray *)objects{
    for (id object in objects){
        [_objects removeObject:object];
    }
    [_collection removeObjects:objects];
}
- (void) removeObjectForKey:(id)key usingKeyPath:(NSString *)keyPath{
    id object = [_collection objectForKey:key usingKeyPath:keyPath];
    if (!object) return;
    [_objects removeObject:object];
    [_collection removeObject:object];
}
- (void) removeObjectAtIndex:(NSUInteger)index{
  	if (index >= _objects.count) return;
    id object = _objects[index];
    if (!object) return;
    [_objects removeObjectAtIndex:index];
    [_collection removeObject:object];
}
- (void) removeAllObjects{
    [_objects removeAllObjects];
    [_collection removeAllObjects];
}
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
    [_objects moveObjectAtIndex:fromIndex toIndex:toIndex];
    [_collection updateOrderOfObject:_objects[toIndex]];
}
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id, NSUInteger, NSUInteger))block{
    [_objects moveObjectAtIndex:fromIndex toIndex:toIndex withBlock:block];
    [_collection updateOrderOfObject:_objects[toIndex]];
}
- (void) swap:(NSUInteger)index with:(NSUInteger)index2{
    [_objects swap:index with:index2];
    [_collection updateOrderOfObjects:Array(_objects[index], _objects[index2])];
}
#pragma mark - Protocol Method
- (id) objectForKeyedSubscript:(id)key{
    return [_collection objectForKeyedSubscript:key];
}
- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)index{
  if (obj){
    [self replaceObjectAtIndex:index withObject:obj];
  } else {
    [self removeObjectAtIndex:index];
  }
}
- (id) objectAtIndexedSubscript:(NSUInteger)index{
  	if (index >= _objects.count) return nil;
    return _objects[index];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len{
    return [_objects countByEnumeratingWithState:state objects:buffer count:len];
}
#pragma mark - Overridden Methods
@end
