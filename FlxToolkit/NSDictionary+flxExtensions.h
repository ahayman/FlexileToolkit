//
//  NSDictionary+ext.h
//  iDB
//
//  Created by Aaron Hayman on 7/25/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (flxExtensions)
- (id)objectForKeyedSubscript: (id)key;
@end

@interface NSMutableDictionary (flxExtensions)
- (void)setObject:(id)obj forKeyedSubscript:(id)key;
@end