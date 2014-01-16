//
//  UIImageExtensions.h
//  iDB
//
//  Created by Aaron Hayman on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (flxExtension)
+ (UIImage *) imageFromImage:(UIImage *) image withColor:(UIColor *) color;
+ (CGPDFDocumentRef) newPDFRefFromFileName:(NSString *)fileName;
+ (UIImage *) imageFromPDFRef:(CGPDFDocumentRef)pdf size:(CGSize)size page:(NSInteger) pageNumber andProportional:(BOOL) proportional;
+ (UIImage *) imageFromPDF:(NSString*)fileName size:(CGSize)size page:(NSInteger) pageNumber andProportional:(BOOL) proportional;
- (NSUInteger) calculatedBytes;
@end
