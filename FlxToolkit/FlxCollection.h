//
//  FlxCollection.h
//  Flexile
//
//  Created by Aaron Hayman on 12/24/13.
//
//

#import <Foundation/Foundation.h>

@interface FlxCollection : NSObject <NSFastEnumeration>
@property (readonly) NSArray *keyPaths;
@property (readonly) NSUInteger count;
+ (instancetype) collectionWithKeyPaths:(NSArray *)keyPaths;
- (instancetype) initWithKeyPaths:(NSArray *)keyPaths;

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
