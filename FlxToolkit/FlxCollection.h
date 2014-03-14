//
//  FlxCollection.h
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult (^FlxCollectionComparator)(id obj1, id obj2);

@protocol FlxCollectionProtocol <NSObject>
- (BOOL) containsObject:(id)object;
- (id) objectForKey:(id)key usingKeyPath:(NSString *)keyPath;
- (id) objectForKey:(id)key;
- (NSArray *) objectsForKey:(id)key usingKeyPath:(NSString *)keyPath;
- (NSArray *) objectsForKey:(id)key;
- (void) addObject:(id)object;
- (void) addObjects:(NSArray *)objects;
- (void) removeObject:(id)object;
- (void) removeObjects:(NSArray *)objects;
- (void) removeObjectForKey:(id)key usingKeyPath:(NSString *)keyPath;
- (void) removeAllObjects;
- (id) objectForKeyedSubscript:(id)key;
@end

@interface FlxCollection : NSObject <FlxCollectionProtocol, NSFastEnumeration>
@property (readonly) NSArray *keyPaths;
@property (readonly) NSUInteger count;
+ (instancetype) collectionWithKeyPaths:(NSArray *)keyPaths;
- (instancetype) initWithKeyPaths:(NSArray *)keyPaths;


- (void) setOrderComparator:(FlxCollectionComparator)comparator forKeyPath:(NSString *)keypath;
- (void) updateOrderOfObject:(id)object;
- (void) updateOrderOfObject:(id)object inKeyPath:(NSString *)keypath;

- (void) updateOrderOfObjects:(NSArray *)objects;
- (void) updateOrderOfObjects:(NSArray *)objects inKeyPath:(NSString *)keypath;

- (void) updateOrderOfAllObjectsInKeyPath:(NSString *)keypath;
@end
