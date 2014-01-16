//
//  FlxObserver.m
//  Flexile
//
//  Created by Aaron Hayman on 11/28/13.
//
//

#import "FlxKVObserver.h"
#import "FlxToolkitDefines.h"
#include <objc/runtime.h>
#include <objc/message.h>

@interface FlxKVObservation ()
@property (strong) id oldValue;
@property (strong) id value;
@property (strong) id observedObject;
@property (readwrite) SEL observedKey;
@end
@implementation FlxKVObservation
@end

//Dict for maintaining observer objects
static NSMutableDictionary * observerDict(id observer){
    if (!observer) return nil;
    static void * const associated_key = (void *)&associated_key;
    NSMutableDictionary *observerDict = objc_getAssociatedObject(observer, associated_key);
    if (!observerDict){
        observerDict = [NSMutableDictionary new];
        objc_setAssociatedObject(observer, associated_key, observerDict, OBJC_ASSOCIATION_RETAIN);
    }
    return observerDict;
}

@interface FlxKVTargetObserver : NSObject
- (id) initWithObservationKey:(SEL)key forObject:(id)object with:(__weak id)observer action:(SEL)action;
- (void) beginObservation;
@end

@interface FlxKVBlockObserver : NSObject
- (id) initWithObservationKey:(SEL)key forObject:(id)object usingChangeBlock:(void (^)(FlxKVObservation *observation))changeBlock;
- (void) beginObservingFrom:(id)observer;
@end

@implementation FlxKVObserver
#pragma mark - Target/Action Observation
+ (void) observeKey:(SEL)key inObject:(__weak id)object target:(__weak id)observer action:(SEL)action{
    FlxKVTargetObserver *obs = [[FlxKVTargetObserver alloc] initWithObservationKey:key forObject:object with:observer action:action];
    [obs beginObservation];
}
+ (void) stopObserving:(SEL)key inObject:(id)object with:(id)observer{
    if (!object || !observer) return;
    observerDict(observer)[@((NSInteger)object)][NSStringFromSelector(key)] = nil;
}
+ (void) stopObservingObject:(id)object with:(id)observer{
    if (!object || !observer) return;
    [observerDict(observer) removeObjectForKey:@((NSInteger)object)];
}
#pragma mark - Block Observation
+ (void) observeKey:(SEL)key inObject:(id)object fromObserver:(__weak id)observer onChange:(void (^)(FlxKVObservation *))changeBlock{
    FlxKVBlockObserver *obs = [[FlxKVBlockObserver alloc] initWithObservationKey:key forObject:object usingChangeBlock:changeBlock];
    [obs beginObservingFrom:observer];
}
+ (void) stopObserver:(id)observer fromObservingKey:(NSString *)key{
    if (!observer || !key) return;
    [observerDict(observer) removeObjectForKey:key];
}
#pragma mark - ===============
+ (void) stopObserving:(id)observed{
    if (!observed) return;
    [observerDict(observed) removeAllObjects];
}
@end

@implementation FlxKVTargetObserver{
    id _observedObject;
    SEL _observedKey;
    __weak id _target;
    SEL _action;
}
#pragma mark - Init Methods
- (id) init{
    return nil;
}
- (id) initWithObservationKey:(SEL)key forObject:(__weak id)object with:(__weak id)observer action:(SEL)action{
    if (observer && object && observer != object && (self = [super init])){
        _target = observer;
        _action = action;
        _observedObject = object;
        _observedKey = key;
    }
    return self;
}
#pragma mark - Private Methods
- (NSMutableDictionary *) objectTargetObservers{
    if (!_target) return nil;
    NSMutableDictionary *observers = observerDict(_target);
    NSNumber *objectID = @((NSInteger)(_observedObject));
    NSMutableDictionary *objectObservers = observers[objectID];
    if (!objectObservers){
        objectObservers = [[NSMutableDictionary alloc] initWithCapacity:2];
        observers[objectID] = objectObservers;
    }
    return objectObservers;
}
#pragma mark - Properties
#pragma mark - Standard Methods
- (void) beginObservation{
    if (!_target) return;
    NSString *keyPath = NSStringFromSelector(_observedKey);
    [self objectTargetObservers][keyPath] = self;
    [_observedObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}
#pragma mark - Protocol Method
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (_target){
        FlxKVObservation *obs = [FlxKVObservation new];
        obs.oldValue = change[NSKeyValueChangeOldKey];
        obs.value = change[NSKeyValueChangeNewKey];
        obs.observedObject = _observedObject;
        obs.observedKey = _observedKey;
        objc_msgSend(_target, _action, obs);
    } else {
        [FlxKVObserver stopObserving:_observedKey inObject:_observedObject with:_target];
    }
}
#pragma mark - Overridden Methods
- (void) dealloc{
    NSString *keyPath = NSStringFromSelector(_observedKey);
    @try {
        [_observedObject removeObserver:self forKeyPath:keyPath];
    }
    @catch (NSException *exception) { }
}
@end

@implementation FlxKVBlockObserver {
    id _observedObject;
    SEL _key;
    IDBlock _changeBlock;
}
#pragma mark - Init Methods
- (id) initWithObservationKey:(SEL)key forObject:(id)object usingChangeBlock:(void (^)(FlxKVObservation *))changeBlock{
    if (object && changeBlock && (self = [super init])){
        _observedObject = object;
        _key = key;
        _changeBlock = [changeBlock copy];
    }
    return self;
}
#pragma mark - Private Methods
- (NSMutableDictionary *) observersForObserver:(id)observer{
    if (!observer) return nil;
    NSMutableDictionary *observers = observerDict(observer);
    NSNumber *objectID = @((NSInteger)(_observedObject));
    NSMutableDictionary *objectObservers = observers[objectID];
    if (!objectObservers){
        objectObservers = [[NSMutableDictionary alloc] initWithCapacity:2];
        observers[objectID] = objectObservers;
    }
    return objectObservers;
}
#pragma mark - Protocol Methods
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (_changeBlock){
        FlxKVObservation *obs = [FlxKVObservation new];
        obs.oldValue = change[NSKeyValueChangeOldKey];
        obs.value = change[NSKeyValueChangeNewKey];
        obs.observedObject = _observedObject;
        obs.observedKey = _key;
        _changeBlock(obs);
    }
}
#pragma mark - Properties
#pragma mark - Standard Methods
- (void) beginObservingFrom:(id)observer{
    if (observer == _observedObject) return;
    NSString *keyPath = NSStringFromSelector(_key);
    [self observersForObserver:observer][keyPath] = self;
    [_observedObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}
#pragma mark - Overridden Methods
- (void) dealloc{
    NSString *keyPath = NSStringFromSelector(_key);
    @try {
        [_observedObject removeObserver:self forKeyPath:keyPath];
    }
    @catch (NSException *exception) { }
}
@end
