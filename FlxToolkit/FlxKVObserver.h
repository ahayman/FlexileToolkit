//
//  FlxObserver.h
//  Flexile
//
//  Created by Aaron Hayman on 11/28/13.
//
//

#import <Foundation/Foundation.h>

@interface FlxKVObservation : NSObject
@property (readonly) id oldValue;
@property (readonly) id value;
@property (readonly) id observedObject;
@property (readonly) SEL observedKey;
@end

@interface FlxKVObserver : NSObject
/**
 Action/Target style Key Value Observation. Observations are attached to the observer, which means when the observer is dealloc'd the observation will also be removed.  
 Only a single observation can be created for each object/key pair from a single observer.  If the observer attempts to create an observation with a previous object/key pair, that previous pair will be replaced.
 It's important to note that the observation retains the observed object and the observation is attached to the observer. This means if the observer will retain the observed object until it stops observing it (if it's replaced or explicitly stopped).
 @param SEL key - The key to be observed
 @param id object - The object on which the key is to be observed. The observed is retained.
 @param id observer - The object doing the observing (also the target for the action).  The observer cannot be the object observed.  The observer is not retained.
 @param SEL action - The action to be called when for value changes.  The action selector can have one argument, to which a FlxKVObservation object will be passed.
 @returns void
 @warning If you don't pass in an object and observer, or the object == observer, nothing will be observerd.
 */
+ (void) observeKey:(SEL)key inObject:(id)object target:(__weak id)observer action:(SEL)action;
/**
 Block style Observation.  Observations are attached to the observed object. When the observed object is dealloc'd, the observation will also be removed.
 Only a single observation can be created for each object/key pair from a single observer.  If the observer attempts to create an observation with a previous object/key pair, that previous pair will be replaced.
 It's important to note that the observation retains the observed object and the observation is attached to the observer. This means if the observer will retain the observed object until it stops observing it (if it's replaced or explicitly stopped).
 @param SEL key - The key to be observed
 @param id object - The object on which the key is to be observed
 @param onChange - Pass the block you want executed when the value changes.
 @returns void
 @warning Be careful of retain cycles.  The observation is attached to the observer, so if your block retains the observer (or another object that does) you'll be leaking some memory. Use __weak to reference self if you're calling this from the observer.
 */
+ (void) observeKey:(SEL)key inObject:(id)object fromObserver:(__weak id)observer onChange:(void (^)(FlxKVObservation *observation))changeBlock;
/**
 Remove Target/Action style observations.  You can't remove Block style observations with this.
 @param SEL key - The key of the observed object you want observations removed.
 @param id object - The observed object
 @param id observer - The observer.
 @returns void
 */
+ (void) stopObserving:(SEL)key inObject:(id)object with:(id)observer;
/**
 Remove all Target/Action style observations for a specific observed object
 @param id object - The object being reserved
 @param id observer - The object doing the observing
 @returns void
 */
+ (void) stopObservingObject:(id)object with:(id)observer;
/**
 This will remove *all* observations for the observer.  Note: If the observer is being dealloc'd, this method is not necessary.
 @param id observer - This is the observer. All observations will be removed.
 @returns void
 @warning This removes *all* observations, including those added by other objects.
 */
+ (void) stopObserving:(id)observed;
@end
