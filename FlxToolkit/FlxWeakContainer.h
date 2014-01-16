//
//  FlxWeakContainer.h
//  Flexile
//
//  Created by Aaron Hayman on 12/19/13.
//
//

#import <Foundation/Foundation.h>

@interface FlxWeakContainer : NSObject
+ (instancetype) contain:(__weak id)object;
@property (weak) id object;
@end
