//
//  FlxWeakContainer.m
//  Flexile
//
//  Created by Aaron Hayman on 12/19/13.
//
//

#import "FlxWeakContainer.h"

@implementation FlxWeakContainer
+ (instancetype) contain:(__weak id)object{
    FlxWeakContainer *cont = [FlxWeakContainer new];
    cont.object = object;
    return cont;
}
@end
