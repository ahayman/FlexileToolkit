//
//  NSMutableURLRequest+ext.m
//  Flexile
//
//  Created by Aaron Hayman on 4/29/13.
//
//

#import "NSMutableURLRequest+flxExtensions.h"

@implementation NSMutableURLRequest (flxExtensions)
+ (NSMutableURLRequest *) getRequestWithURLString:(NSString *)string{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    request.HTTPMethod = @"GET";
    return request;
}
+ (NSMutableURLRequest *) postRequestWithURLString:(NSString *)string data:(NSData *)data contentType:(NSString *)contentType{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    request.HTTPMethod = @"POST";
    if (data)
        request.HTTPBody = data;
    if (contentType)
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
+ (NSMutableURLRequest *) putRequestWithURLString:(NSString *)string data:(NSData *)data{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    request.HTTPMethod = @"PUT";
    if (data){
        request.HTTPBody = data;
    }
    [request addValue:[@(data.length) stringValue] forHTTPHeaderField:@"Content-Length"];
    return  request;
}
+ (NSMutableURLRequest *) putRequestWithURLString:(NSString *)string data:(NSData *)data contentType:(NSString *)contentType{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    request.HTTPMethod = @"PUT";
    if (data)
        request.HTTPBody = data;
    if (contentType)
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:[@(data.length) stringValue] forHTTPHeaderField:@"Content-Length"];
    
    return request;
}
+ (NSMutableURLRequest *) deleteRequestWithURLString:(NSString *)string data:(NSData *)data contentType:(NSString *)contentType{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    request.HTTPMethod = @"DELETE";
    if (data)
        request.HTTPBody = data;
    if (contentType)
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    return request;
}
@end
