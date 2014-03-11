//
//  NSObject+ext.h
//  iDB
//
//  Created by Aaron Hayman on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (flxExtensions)
/**
 Accessing this property will create an associated NSMutableDictionary attached to this object.  You can use this dictionary to attach arbitrary data to any NSObject.  It's very useful if you don't want to subclass just to get a few extra properties.
 **/
@property (readonly) NSMutableDictionary *associatedInfo;
/**
 This will compare two objects taking in to account nil values and class types. Class type comparison is done using 'isKindOfClass' on 'object2'.  If either object responds to 'equalTo:', this will be used.  Otherwise, direct pointer comparison will be used.
 **/
+ (BOOL) object:(id)object1 equalTo:(id)object2;
/**
 *  This will perform the specified selector on the main thread only once.  Attempts to perform the selector additional times before it has been performed will be ignored.  After the selector has been performed, you can then perform it again if you need to.  Use this method to prevent the selector from being fired multiple times.
 *
 *  @param selector The selector you want to perform
 *  @param object   The object you want to send to the selector
 *  @param delay    The delay you want until the selector is performed.
 */
- (void) performSelectorOnceOnMain:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay;
/**
 *  This will perform the selector after a delay of 0. This should perform the selector at the end of the run loop. Additional attempts to perform the selector before it has been performed will be ignored.  The selector is performed using `NSRunLoopCommonModes`.
 *
 *  @param selector The selector you want to perform.
 */
- (void) performSelectorOnceAfterDelay:(SEL)selector;
@end
