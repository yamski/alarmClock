//
//  ACAtweetView.m
//  alarmClock
//
//  Created by JOHN YAM on 6/16/14.
//  Copyright (c) 2014 John Yam. All rights reserved.
//

#import "ACAtweetView.h"

#import <Accelerate/Accelerate.h>

@implementation ACAtweetView

- (UIImage *)blurView
{
    UIGraphicsBeginImageContext(self.bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, self.bounds);
    
    [self.layer renderInContext:context];
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	vImage_Buffer inBuffer;
	inBuffer.data = CGBitmapContextGetData(context);
	inBuffer.width = CGBitmapContextGetWidth(context);
	inBuffer.height = CGBitmapContextGetHeight(context);
	inBuffer.rowBytes = CGBitmapContextGetBytesPerRow(context);
    
	UIGraphicsBeginImageContext(self.bounds.size);
	CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
	vImage_Buffer outBuffer;
	outBuffer.data = CGBitmapContextGetData(effectOutContext);
	outBuffer.width = CGBitmapContextGetWidth(effectOutContext);
	outBuffer.height = CGBitmapContextGetHeight(effectOutContext);
	outBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
	
	CGFloat blurRadius = 10;
	CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
	int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
	if (radius % 2 != 1) { radius += 1; }
	vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
	vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
	vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
	
    
	// add tint
	UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    //tintColor = [UIColor colorWithRed:7/255.0 green:224/255.0 blue:156/255.0 alpha:0.7];
	
	CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context, tintColor.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
	CGContextRestoreGState(context);
	
	
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
	
	UIGraphicsEndImageContext();
	UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    
    
    return returnImage;
}


@end
