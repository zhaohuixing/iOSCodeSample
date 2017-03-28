//
//  ImageLoader.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 zhaohuixing. All rights reserved.
//
#import "ImageLoader.h"

@implementation ImageLoader

+(CGImageRef)LoadResourceImage:(NSString*)imageName
{
	CGImageRef cgImage = NULL;
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
	UIImage* uiImagge = [UIImage imageWithContentsOfFile:imagePath];
	
    cgImage = CGImageRetain(uiImagge.CGImage);
	
	return cgImage;
}	

+(CGImageRef)LoadImageWithName:(NSString*)imageName
{
	CGImageRef cgImage = NULL;
	
	UIImage* uiImagge = [UIImage imageNamed:imageName];
	
	cgImage = CGImageRetain(uiImagge.CGImage);
	
	return cgImage;
}

+(CGImageRef)getTransformResizImage:(CGImageRef)realImage subRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, rect.size.width, rect.size.height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, realImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
	return retImage;
}

+(CGImageRef)LoadImage:(NSString*)imageName withWidth:(float)width withHeight:(float)height
{
    CGImageRef srcImage = [ImageLoader LoadImageWithName:imageName];

	float imgWidth = CGImageGetWidth(srcImage);
	float imgHeight = CGImageGetHeight(srcImage);
    BOOL bRotate = NO;
    
    float fImgRatio = imgWidth/imgHeight;
    float fDstRatio = width/height;
    
    if((fImgRatio < 1.0 && 1.0 < fDstRatio) || (1.0 < fImgRatio && fDstRatio < 1.0))
        bRotate = YES;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    
    if(bRotate)
    {
		float cx = width/2;
        float cy = height/2;
        rect = CGRectMake((width-height)/2, (height-width)/2, height, width);
        CGContextTranslateCTM(bitmapContext, cx, cy);
        
		float angle = 90;
		CGContextRotateCTM(bitmapContext, angle*M_PI/180.0f);
		
		CGContextTranslateCTM(bitmapContext, -cx, -cy);
    }
    
	CGContextDrawImage(bitmapContext, rect, srcImage);
    CGContextRestoreGState(bitmapContext);
    
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    //CGImageRelease(srcImage);
	return retImage;
}
@end
