//
//  LinkedList.h
//  iDB
//
//  Created by Aaron Hayman on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlxLinkListIterator;

@interface FlxLinkedList : NSObject <NSFastEnumeration, NSCopying>
@property NSUInteger count;
@property (nonatomic, readonly) NSArray *array;

+ (FlxLinkedList *) listWithObject:(id)object;
+ (FlxLinkedList *) linkedListFromArray:(NSArray *)array;
+ (FlxLinkedList *) linkedListFromArray:(NSArray *)array reverseEnumeration:(BOOL)reverse;
- (id) initWithValue:(id)value;
- (void) push:(id)value;
- (id) peek;
- (id) pop; 
- (void) add:(id)value;
- (void) deleteList;
- (NSUInteger) count;
- (FlxLinkListIterator *) newIterator;
- (id) objectAtIndexedSubscript:(NSUInteger)index;
@end

@interface FlxLinkListIterator : NSObject <NSFastEnumeration>
- (id) initWithLinkedList:(FlxLinkedList *)list;
- (id) next;
- (id) removeCurrent;
- (void) alterCurrentTo:(id)value;
- (void) insertInFrontOfCurrent:(id)value;
- (void) insertAfterCurrent:(id)value;
@end