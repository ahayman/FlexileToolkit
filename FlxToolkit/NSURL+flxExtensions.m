//
//  NSURL+ext.m
//  Flexile
//
//  Created by Aaron Hayman on 5/7/13.
//
//

#import "NSURL+flxExtensions.h"

@implementation NSURL (flxExtensions)
- (NSDictionary *) parameters{
    NSArray *pairValues = [self.query componentsSeparatedByString:@"&"];
    if (!pairValues.count) return nil;
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionaryWithCapacity:pairValues.count];
    for (NSString *pair in pairValues){
        NSArray *values = [pair componentsSeparatedByString:@"="];
        paramaters[[values.firstObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] = [values.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return paramaters;
}
@end
