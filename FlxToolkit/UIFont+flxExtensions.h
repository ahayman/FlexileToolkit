//
//  UIFontExtensions.h
//  iDB
//
//  Created by Aaron Hayman on 9/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFont (flxExtensions)

- (NSString *) fontString;
+ (UIFont *) UIFontForString:(NSString *)fontString;
@end
