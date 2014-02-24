//
//  UIResponder+flxExtensions.m
//  FlxToolkit
//
//  Created by Aaron Hayman on 2/24/14.
//  Copyright (c) 2014 Aaron Hayman. All rights reserved.
//

#import "UIResponder+flxExtensions.h"

static __weak id currentFirstResponder;

@implementation UIResponder (flxExtensions)
+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
@end
