//
//  FlxOrderedCollection.h
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import <Foundation/Foundation.h>
#import "FlxCollection.h"

@interface FlxOrderedCollection : NSObject <FlxCollectionProtocol, NSFastEnumeration>
@property (readonly) NSArray *keyPaths;
@property (readonly) NSUInteger count;
@property (readonly) NSArray *objects;
@property (readonly) id firstObject;
@property (readonly) id lastObject;
@property (readonly) NSUInteger lastIndex;
+ (instancetype) collectionWithKeyPaths:(NSArray *)keyPaths;
- (instancetype) initWithKeyPaths:(NSArray *)keyPaths;

- (id) objectAtIndex:(NSUInteger)index;
- (NSUInteger) indexOfObject:(id)object;
- (void) insertObject:(id)object atIndex:(NSUInteger)index;
- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id object, NSUInteger from, NSUInteger to))block;
- (void) swap:(NSUInteger)index with:(NSUInteger)index2;
- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)index;
- (id) objectAtIndexedSubscript:(NSUInteger)index;
@end
