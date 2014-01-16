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
@end
