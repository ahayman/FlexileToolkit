//
//  FlxCollection.m
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import "FlxCollection.h"
#import "FlxKVObserver.h"
#import "FlxToolkitExtensions.h"

@implementation FlxCollection{
    NSMutableDictionary *_collections;
    NSMutableDictionary *_comparators;
    NSMutableSet *_objects;
}
#pragma mark - Class Methods
#pragma mark - Init Methods
+ (instancetype) collectionWithKeyPaths:(NSArray *)keyPaths{
    return [[FlxCollection alloc] initWithKeyPaths:keyPaths];
}
- (id) init{
    return nil;
}
- (instancetype) initWithKeyPaths:(NSArray *)keyPaths{
    if (!keyPaths.count) return nil;
    if (self = [super init]){
        _keyPaths = keyPaths;
        _collections = [NSMutableDictionary new];
        _comparators = [NSMutableDictionary new];
        _objects = [NSMutableSet new];
        for (NSString *key in keyPaths){
            _collections[key] = [NSMutableDictionary new];
        }
    }
    return self;
}
#pragma mark - Private Methods
- (void) observedValueChange:(FlxKVObservation *)observation{
    NSString *key = NSStringFromSelector(observation.observedKey);
    id value = observation.oldValue;
    if (value){
        id current = _collections[key][observation.oldValue];
        if ([current isKindOfClass:[NSMutableArray class]]){
            if ([current count] < 2){
                _collections[key][observation.oldValue] = nil;
            } else {
                [current removeObject:observation.observedObject];
            }
        } else {
            _collections[key][observation.oldValue] = nil;
        }
    }
    value = observation.value;
    if (observation.value){
        id current = _collections[key][value];
        if (!current){
            _collections[key][value] = observation.observedObject;
        } else if ([current isKindOfClass:[NSMutableArray class]]){
            FlxCollectionComparator comparator = _comparators[key];
            if (comparator){
                [current insertObject:observation.observedObject withComparator:comparator];
            } else {
                [current addObject:observation.observedObject];
            }
        } else {
            FlxCollectionComparator comparator = _comparators[key];
            if (comparator){
                NSMutableArray *array = MArray(current);
                [array insertObject:observation.observedObject withComparator:comparator];
                _collections[key][value] = array;
            } else {
                _collections[key][value] = MArray(current, observation.observedObject);
            }
        }
    }
}
#pragma mark - Properties
- (NSUInteger) count{
    return _objects.count;
}
#pragma mark - Standard Methods
- (BOOL) containsObject:(id)object{
    if (!object) return NO;
    return [_objects containsObject:object];
}
- (id) objectForKey:(id)key usingKeyPath:(NSString *)keyPath{
    if (!key || !keyPath) return nil;
    id object = _collections[keyPath][key];
    if ([object isKindOfClass:[NSArray class]]){
        return [object firstObject];
    } else {
        return object;
    }
}
- (id) objectForKey:(id)key{
    if (!key) return nil;
    id object = _collections[_keyPaths.firstObject][key];
    if ([object isKindOfClass:[NSArray class]]){
        return [object firstObject];
    } else {
        return object;
    }
}
- (NSArray *) objectsForKey:(id)key usingKeyPath:(NSString *)keyPath{
    if (!key || !keyPath) return nil;
    id object = _collections[keyPath][key];
    if ([object isKindOfClass:[NSArray class]]){
        return object;
    } else {
        return Array(object);
    }
}
- (NSArray *) objectsForKey:(id)key{
    if (!key) return nil;
    id object = _collections[_keyPaths.firstObject][key];
    if ([object isKindOfClass:[NSArray class]]){
        return object;
    } else {
        return Array(object);
    }
}
- (void) addObject:(id)object{
    if (!object) return;
    if ([self containsObject:object]) return;
    
    [_objects addObject:object];
    
    for (NSString *key in _keyPaths){
        id objectValue = [object valueForKeyPath:key];
        if (objectValue){
            id currentObject = _collections[key][objectValue];
            if (!currentObject){
                _collections[key][objectValue] = object;
            } else if ([currentObject isKindOfClass:[NSMutableArray class]]){
                FlxCollectionComparator comparator = _comparators[key];
                if (comparator){
                    [currentObject insertObject:object withComparator:comparator];
                } else {
                    [currentObject addObject:object];
                }
            } else {
                FlxCollectionComparator comparator = _comparators[key];
                if (comparator){
                    NSMutableArray *array = MArray(currentObject);
                    [array insertObject:object withComparator:comparator];
                    _collections[key][objectValue] = array;
                } else {
                    _collections[key][objectValue] = MArray(currentObject, object);
                }
            }
        }
        [FlxKVObserver observeKey:NSSelectorFromString(key) inObject:object target:self action:@selector(observedValueChange:)];
    }
}
- (void) addObjects:(NSArray *)objects{
    for (id object in objects){
        [self addObject:object];
    }
}
- (void) removeObject:(id)object{
    if (!object) return;
    [_objects removeObject:object];
    
    //Extract Keys
    for (NSString *key in _keyPaths){
        //First check that we're not already tracking the object
        id objectValue = [object valueForKeyPath:key];
        
        if (objectValue){
            _collections[key][objectValue] = nil;
        }
    }
    [FlxKVObserver stopObservingObject:object with:self];
}
- (void) removeObjects:(NSArray *)objects{
    for (id object in objects){
        [self removeObject:object];
    }
}
- (void) removeObjectForKey:(id)key usingKeyPath:(NSString *)keyPath{
    [self removeObject:[self objectForKey:key usingKeyPath:keyPath]];
}
- (void) removeAllObjects{
    for (NSString *key in _keyPaths){
        [_collections[key] removeAllObjects];
    }
    for (id object in _objects){
        [FlxKVObserver stopObservingObject:object with:self];
    }
}
- (void) setOrderComparator:(FlxCollectionComparator)comparator forKeyPath:(NSString *)keypath{
    if (!keypath) return;
    _comparators[keypath] = comparator;
    
    [self updateOrderOfAllObjectsInKeyPath:keypath];
}
- (void) updateOrderOfObject:(id)object{
    [self updateOrderOfObjects:Array(object)];
}
- (void) updateOrderOfObjects:(NSArray *)objects{
    for (NSString *keyPath in _comparators.allKeys){
        [self updateOrderOfObjects:objects inKeyPath:keyPath];
    }
}
- (void) updateOrderOfObject:(id)object inKeyPath:(NSString *)keypath{
    if (!object || !keypath) return;
    [self updateOrderOfObjects:Array(object) inKeyPath:keypath];
}
- (void) updateOrderOfObjects:(NSArray *)objects inKeyPath:(NSString *)keypath{
    if (!keypath || !objects.count) return;
    
    FlxCollectionComparator comparator = _comparators[keypath];
    if (!comparator) return;
    
    //To preserve ordering, we first remove all objects from their leaf arrays and then re-add them in separate operations.  This ensures that another object that needs to be reordered isn't skewing the comparator results by being present in the array.
    NSMutableArray *leafArrays = [NSMutableArray new];
    for (id object in objects){
        id value = [object valueForKeyPath:keypath];
        if (!value){
            [leafArrays addObject:[NSNull null]];
        } else {
            [leafArrays addObject:(_collections[keypath][value]) ? : [NSNull null]];
        }
    }
    
    for (int i = 0; i < objects.count; i++){
        id object = objects[i];
        NSMutableArray *leafArray = leafArrays[i];
        if ([leafArray isKindOfClass:[NSMutableArray class]]){
            [leafArray removeObject:object];
        }
    }
    
    for (int i = 0; i < objects.count; i++){
        id object = objects[i];
        NSMutableArray *leafArray = leafArrays[i];
        if ([leafArray isKindOfClass:[NSMutableArray class]]){
            [leafArray insertObject:object withComparator:comparator];
        }
    }
}
- (void) updateOrderOfAllObjectsInKeyPath:(NSString *)keypath{
    if (!keypath) return;
    FlxCollectionComparator comparator = _comparators[keypath];
    if (comparator){
        NSDictionary *collection = _collections[keypath];
        for (NSMutableArray *objects in collection.allValues){
            if ([objects isKindOfClass:[NSMutableArray class]]){
                [objects sortUsingComparator:comparator];
            }
        }
    }
}
#pragma mark - Protocol Method
- (id) objectForKeyedSubscript:(id)key{
    if (!key) return nil;
    return _collections[_keyPaths.firstObject][key];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len{
    return [_objects countByEnumeratingWithState:state objects:buffer count:len];
}
#pragma mark - Overridden Methods
@end
