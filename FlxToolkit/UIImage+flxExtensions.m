//
//  UIImageExtensions.m
//  iDB
//
//  Created by Aaron Hayman on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+flxExtensions.h"
#import "FlxToolkitFunctions.h"

@implementation UIImage (flxExtension)

#define DEG_TO_RAD(a) (a * (3.14159 / 180.0))

+ (UIImage *) imageFromImage:(UIImage *) image withColor:(UIColor *) color {
	UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
	//
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	// Flip the image
	CGContextTranslateCTM(context, 0.0, imageRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSaveGState(context);
	CGContextDrawImage(context, imageRect, image.CGImage);
	//
	// Create Clip Mask from Image
	CGContextClipToMask(context, imageRect, image.CGImage);
	// Color it
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextSetBlendMode(context, kCGBlendModeColorBurn);
	//
	CGContextAddRect(context, imageRect);
	CGContextDrawPath(context, kCGPathFill);
	CGContextRestoreGState(context);
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}
+ (CGPDFDocumentRef) newPDFRefFromFileName:(NSString *)fileName{
    if (fileName){
        CFStringRef stringRef = (__bridge_retained CFStringRef)fileName;
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), stringRef, NULL, NULL);
        CFRelease(stringRef);
        if (pdfURL) {       
            
            CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(pdfURL);
            CFRelease(pdfURL);  
            return pdf;
        }
    }
    return nil;
}
+ (UIImage *) imageFromPDF:(NSString*)fileName size:(CGSize)size page:(NSInteger) pageNumber andProportional:(BOOL) proportional {
    if (fileName){
        CGPDFDocumentRef pdf = [self newPDFRefFromFileName:fileName];
        UIImage *image = [self imageFromPDFRef:pdf size:size page:pageNumber andProportional:proportional];
        CGPDFDocumentRelease(pdf);
        return image;
    } else {
        FlxLog(@"UIImageExtensions.UIImageFromPDF: Could not load file named: %@", fileName);
        return nil;
    }
}
+ (UIImage *) imageFromPDFRef:(CGPDFDocumentRef)pdf size:(CGSize)size page:(NSInteger) pageNumber andProportional:(BOOL) proportional{
	
    if (pdf){
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, pageNumber);
        CGRect SourceBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        
        //This resizes the context size to fit the image proportions.  This way we don't have an image with a bunch of empty space
        if (proportional){
            if (SourceBox.size.width > SourceBox.size.height){
                if (SourceBox.size.width / ((SourceBox.size.height) ? : 1.0f) > size.width / ((size.height) ? : 1.0f))
                    size.height = size.width * (SourceBox.size.height / ((SourceBox.size.width) ? : 1.0f));
                 else
                     size.width = size.height * (SourceBox.size.width / ((SourceBox.size.height) ? : 1.0f));

            } else {
                if (SourceBox.size.height / ((SourceBox.size.width) ? : 1.0f) > size.height / ((size.width) ? : 1.0f))
                    size.width = size.height * (SourceBox.size.width / ((SourceBox.size.height) ? : 1.0f));
                else 
                    size.height = size.width * (SourceBox.size.height / ((SourceBox.size.width) ? : 1.0f));
            }
        }
        
		UIGraphicsBeginImageContextWithOptions(size,NO,0.0);        
        
		CGContextRef context = UIGraphicsGetCurrentContext();
		//translate the content
		CGContextTranslateCTM(context, 0.0, size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextSaveGState(context);

		int rotation = CGPDFPageGetRotationAngle(page);
        
		// We manually scale PDF because the PDF routines only scale down. We can do both.
		CGSize ScaleBox = CGSizeMake(size.width / ((SourceBox.size.width) ? : 1.0f), size.height / ((SourceBox.size.height) ? : 1.0f));
		if (proportional)
			ScaleBox.width = ScaleBox.height = MIN(ScaleBox.width,ScaleBox.height);
        
		CGAffineTransform pdfTransform = CGAffineTransformIdentity;
		pdfTransform = CGAffineTransformScale(pdfTransform,ScaleBox.width, ScaleBox.height);
		CGContextConcatCTM(context, pdfTransform);

		// Rotation (Translate to center, rotate, translate back)
		CGAffineTransform rotate = CGAffineTransformMakeTranslation(SourceBox.size.width/2, SourceBox.size.height/2);
		rotate = CGAffineTransformRotate(rotate, DEG_TO_RAD(rotation));
		rotate = CGAffineTransformTranslate(rotate, -SourceBox.size.width/2, -SourceBox.size.height/2);
		CGContextConcatCTM(context, rotate);

		CGContextDrawPDFPage(context, page); 
        
		CGContextRestoreGState(context);
        
		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
	}else {
        return nil;
    }
}
- (NSUInteger) calculatedBytes{
    return CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
}
@end