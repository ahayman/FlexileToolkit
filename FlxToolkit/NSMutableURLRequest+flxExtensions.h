//
//  NSMutableURLRequest+ext.h
//  Flexile
//
//  Created by Aaron Hayman on 4/29/13.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (flxExtensions)
+ (NSMutableURLRequest *) getRequestWithURLString:(NSString *)string;
+ (NSMutableURLRequest *) postRequestWithURLString:(NSString *)string data:(NSData *)data contentType:(NSString *)contentType;
+ (NSMutableURLRequest *) putRequestWithURLString:(NSString *)string data:(NSData *)data;
+ (NSMutableURLRequest *) putRequestWithURLString:(NSString *)string data:(NSData *)data contentType:(NSString *)contentType;
+ (NSMutableURLRequest *) deleteRequestWithURLString:(NSString *)string data:(NSData *)data contentType:(NSString *)contentType;
@end
