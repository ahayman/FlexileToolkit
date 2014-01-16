//
//  NSMutableArrayExtension.h
//  iDB
//
//  Created by Aaron Hayman on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define lastObj ULONG_MAX
#define Array(...)   [NSArray arrayWithObjects:__VA_ARGS__,nil]
#define MArray(...)  [NSMutableArray arrayWithObjects:__VA_ARGS__,nil]

@interface NSArray (flxExtensions)
+ (NSArray *) arrayWithArray:(NSArray *)array typeCheck:(Class)classType;
- (id) firstObject;
- (id) objectAtIndexedSubscript:(NSUInteger)index;
- (id) objectForKeyedSubscript:(id)key;
- (NSUInteger) lastIndex;
@end

@interface NSMutableArray (flxExtensions)
+ (NSMutableArray *) arrayWithArray:(NSArray *)array typeCheck:(Class)classType;
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id object, NSUInteger from, NSUInteger to))block;
- (void) invertArray;
- (void) invertArrayWithOperationBlock:(void(^)(id object, NSUInteger from, NSUInteger to))block;
- (void) swap:(NSUInteger)index with:(NSUInteger)index2;
- (void) push:(id)object;
- (id) pop;
- (id) peek;
- (NSUInteger) append:(id)objectOrArray;
- (NSUInteger)    insertObject:(id)object withComparator:(NSComparisonResult (^)(id object1, id object2))block;
- (NSUInteger) insertionIndexOfObject:(id)object withComparator:(NSComparisonResult (^)(id object1, id object2))block;
- (void)setObject: (id)obj atIndexedSubscript: (NSUInteger)index;
- (void) addDistinctObjects:(NSArray *)objects;
- (id) deepCopy;
@end
