//
//  UILabelExtensions.m
//  iDB
//
//  Created by Aaron Hayman on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILabel+flxExtensions.h"


@implementation UILabel (flxExtensions)
- (void) increaseFontSize{
    self.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize + 1];
}
- (void) decreaseFontSize{
    self.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize - 1];
}
- (void) setFontName:(NSString *)fontName{
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}
- (void) setFontSize:(NSUInteger)size{
    self.font = [UIFont fontWithName:self.font.fontName size:size];
}
@end