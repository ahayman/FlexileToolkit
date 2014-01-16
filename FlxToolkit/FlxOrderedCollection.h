//
//  FlxOrderedCollection.h
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import <Foundation/Foundation.h>

@interface FlxOrderedCollection : NSObject <NSFastEnumeration>
@property (readonly) NSArray *keyPaths;
@property (readonly) NSUInteger count;
@property (readonly) NSArray *objects;
@property (readonly) id firstObject;
@property (readonly) id lastObject;
@property (readonly) NSUInteger lastIndex;
+ (instancetype) collectionWithKeyPaths:(NSArray *)keyPaths;
- (instancetype) initWithKeyPaths:(NSArray *)keyPaths;

- (BOOL) containsObject:(id)object;
- (id) objectForKey:(id)key usingKeyPath:(NSString *)keyPath;
- (id) objectForKey:(id)key;
- (NSArray *) objectsForKey:(id)key usingKeyPath:(NSString *)keyPath;
- (NSArray *) objectsForKey:(id)key;
- (id) objectAtIndex:(NSUInteger)index;
- (NSUInteger) indexOfObject:(id)object;
- (void) addObject:(id)object;
- (void) addObjects:(NSArray *)objects;
- (void) insertObject:(id)object atIndex:(NSUInteger)index;
- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (void) removeObject:(id)object;
- (void) removeObjectForKey:(id)key usingKeyPath:(NSString *)keyPath;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) removeAllObjects;
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id object, NSUInteger from, NSUInteger to))block;
- (void) swap:(NSUInteger)index with:(NSUInteger)index2;
- (id) objectForKeyedSubscript:(id)key;
- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)index;
- (id) objectAtIndexedSubscript:(NSUInteger)index;
@end
