//
//  LinkedList.m
// 
//
//  Created by Aaron Hayman on 6/28/11.
//

#import "FlxLinkedList.h"
@class ListNode;

@interface FlxLinkedList ()
@property (strong, readonly) ListNode *head;
@end

@interface ListNode : NSObject 
@property (strong) id value;
@property (strong) ListNode *next;
- (id) initWithValue:(id)newValue;
- (id) initWithValue:(id)newValue nextNode:(ListNode *)nextNode;
@end

@implementation ListNode {
    id value;
    ListNode *next;    
}
@synthesize value, next;
- (id) init{
    return [self initWithValue:nil];
}
- (id) initWithValue:(id)newValue{
    return [self initWithValue:newValue nextNode:nil];
}
- (id) initWithValue:(id)newValue nextNode:(ListNode *)nextNode{
    self = [super init];
    if (self){
        value = newValue;
        next = nextNode;
    }
    return self;
}
@end

@implementation FlxLinkedList {
    ListNode *_head;
    NSUInteger _count;
    ListNode *_tail;
    ListNode *_cache;
}
#pragma mark -
#pragma mark Init Methods
+ (FlxLinkedList *) listWithObject:(id)object{
    return [[FlxLinkedList alloc] initWithValue:object];
}
+ (FlxLinkedList *) linkedListFromArray:(NSArray *)array{
    return [FlxLinkedList linkedListFromArray:array reverseEnumeration:NO];
}
+ (FlxLinkedList *) linkedListFromArray:(NSArray *)array reverseEnumeration:(BOOL)reverse{
    FlxLinkedList *list = [[FlxLinkedList alloc] init];
    for (id object in array){ 
        reverse ? [list push:object] : [list add:object];
    }
    return list;
}
- (id)init{
    return [self initWithValue:nil];
}
- (id)initWithValue:(id)value{
    self = [super init];
    if (self){
        _head = value ? [[ListNode alloc] initWithValue:value] : nil;
        _tail = _head;
        _count = value ? 1 : 0;
    }
    return self;
}
@synthesize count=_count;
#pragma mark -
#pragma mark Protocol Methods
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len{
    
    ListNode *currentNode;
    if (state->state == 0){
        state->mutationsPtr = &state->extra[0];
        currentNode = _head;
    } else if (state->state == 1) return 0;
    else currentNode = (__bridge ListNode *)(void*)state->state;
    
    NSUInteger count = 0;
    while (currentNode && count < len){
        buffer[count++] = currentNode.value;
        currentNode = currentNode.next;
    }
    
    state->itemsPtr = buffer;
    state->state = (currentNode) ? (unsigned long)currentNode : 1;
    return count;
}
- (id) copyWithZone:(NSZone *)zone{
    FlxLinkedList *list = [[FlxLinkedList alloc] init];
    for (id object in self) [list add:object];
    return list;
}
#pragma mark -
#pragma mark Standard Methods
- (void) push:(id)value{
    ListNode *newNode  = (_cache) ? _cache : [[ListNode alloc] init];
    newNode.value = value;
    newNode.next = _head;
    _cache = nil;
    if (!_head) _tail = newNode;
    _head = newNode;
    _count++;
}
- (id) peek{
    return _head.value;
}
- (id) pop{
    if (!_head) return nil;
    id returnedValue = _head.value;
    _cache = _head;
    _head = _head.next;
    _cache.value = nil;
    _cache.next = nil;
    _count--;
    if (!_head) _tail = nil;
    return returnedValue;
}
- (void) add:(id)value{
    if (!_tail) {
        [self push:value];
        return;
    }
    ListNode *newNode = (_cache) ? _cache : [[ListNode alloc] init];
    newNode.value = value;
    _cache = nil;
    _tail.next = newNode;
    _tail = newNode;
    _count++;
}
- (void) deleteList{
    _head = nil;
    _tail = nil;
    _count = 0;
}
- (id) objectAtIndexedSubscript:(NSUInteger)index{
    if (index == 0) return _head.value;
    if (index == self.count - 1) return _tail.value;
    if (index >= self.count) return nil;
    
    NSUInteger current = 0;
    for (id object in self){
        if (current == index){
            return object;
        } else {
            current++;
        }
    }
    return nil;
}
- (FlxLinkListIterator *) newIterator{
    return [[FlxLinkListIterator alloc] initWithLinkedList:self];
}
#pragma mark - Overwritten methods
- (NSString *) description{
    int count = 0;
    NSMutableString *description = [NSMutableString stringWithString:@"Linked List: { \n"];
    for (id object in self){
        [description appendFormat:@"    %i : %@, \n", count, [object description]];
        count++;
    }
    [description appendFormat:@"}"];
    return description;
}
@end



@implementation FlxLinkListIterator {
    ListNode *_current;
    ListNode *_previous;
}
- (id) initWithLinkedList:(FlxLinkedList *)list{
    self = [super init];
    if (self){
        _current = list ? list.head : nil;
        _previous = nil;
    }
    return self;
}
- (id) next{
    id returnedValue = _current.value;
    _previous = _current;
    _current = _current.next;
    return returnedValue;
}
- (id) removeCurrent{
    if (!_current) return nil;
    id returnedValue = _current.value;
    _previous.next = _current.next;
    
    ListNode *tmpNode = _current;
    _current = _current.next;
    tmpNode.next = nil;
    tmpNode.value = nil;
    
    return returnedValue;
}
- (void) alterCurrentTo:(id)value{
    _current.value = value;
}
- (void) insertInFrontOfCurrent:(id)value{
    ListNode *newNode = [[ListNode alloc] initWithValue:value nextNode:_current];
    _previous.next = newNode;
    _previous = newNode;
}
- (void) insertAfterCurrent:(id)value{
    ListNode *newNode = [[ListNode alloc] initWithValue:value nextNode:_current.next];
    _current.next = newNode;
    _previous = _current;
    _current = newNode;
}
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len{
    //This is a slow method of iteration, but easily allows for mutation
    if (!_current) return 0;
    if (state->state == 0) state->mutationsPtr = &state->extra[0];
    buffer[0] = _current.value;
    _current = _current.next;
    state->itemsPtr = buffer;
    return 1;
}
@end