//
//  UILabelExtensions.h
//  iDB
//
//  Created by Aaron Hayman on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (flxExtensions)
- (void) increaseFontSize;
- (void) decreaseFontSize;
- (void) setFontName:(NSString *)fontName;
- (void) setFontSize:(NSUInteger)size;
@end