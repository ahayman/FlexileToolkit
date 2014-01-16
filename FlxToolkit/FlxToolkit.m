//
//  FlxToolkit.m
//  Flexile
//
//  Created by Aaron Hayman on 1/14/14.
//
//

#import "FlxToolkit.h"

@interface NSObject (BlockCall)
- (void) executeCallBlock;
@end
@implementation NSObject (BlockCall)
- (void) executeCallBlock{
    void (^block)(void) = (id)self;
    block();
}
@end

void DebugLog(NSString *format,...) {
    va_list ap;
    va_start (ap, format);
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body =  [[NSString alloc] initWithFormat: format arguments: ap];
    va_end (ap);
    fprintf(stderr,"%s",[body UTF8String]);
}

void ExecuteBlockAfterDelay(NSTimeInterval delay, VoidBlock block){
    [[block copy] performSelector: @selector(executeCallBlock) withObject: nil afterDelay: delay inModes:Array(NSRunLoopCommonModes)];
}

BOOL CGRectIsEqualToRect(CGRect rect1, CGRect rect2){
    return (rect1.origin.y == rect2.origin.y &&
            rect1.origin.x == rect2.origin.x &&
            rect1.size.width == rect2.size.width &&
            rect1.size.height == rect2.size.height);
}


NSUInteger DeviceSystemMajorVersion(void) {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

void fBound(CGFloat *x, CGFloat lower, CGFloat upper){
    *x = MAX(lower, MIN(upper, *x));
}