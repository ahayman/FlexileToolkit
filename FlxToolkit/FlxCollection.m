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
            [current addObject:observation.observedObject];
        } else {
            _collections[key][value] = MArray(current, observation.observedObject);
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
    //Extract Keys
    for (NSString *key in _keyPaths){
        //First check that we're not already tracking the object
        id objectValue = [object valueForKeyPath:key];
        
        if (objectValue){
            //Check if there's already an object stored
            id currentObject = _collections[key][objectValue];
            if (!currentObject){
                _collections[key][objectValue] = object;
            } else if ([currentObject isKindOfClass:[NSMutableArray class]]){
                [currentObject addObject:object];
            } else {
                _collections[key][objectValue] = MArray(currentObject, object);
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
