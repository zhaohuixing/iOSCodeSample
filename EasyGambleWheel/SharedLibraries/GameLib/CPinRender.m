//
//  CPinRender.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-10-10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CPinRender.h"
#import "CCompassRender.h"
#import "ApplicationConfigure.h"
#import "ImageLoader.h"

@implementation CPinRender

+(CGFloat)GetPointerImageLength
{
    CGFloat fSize = [CCompassRender GetCompassImageSize];
    CGFloat edge = fSize/10.0;
    CGFloat fRet = fSize/2.0 - edge;
    return fRet;
}

+(CGFloat)GetPointerImageWidth
{
    CGFloat fRet = [CPinRender GetPointerImageLength]/3.0;
    return fRet;
}

+(CGFloat)GetPointerImageInnerWidth
{
    CGFloat fRet = [CPinRender GetPointerImageLength]/6.0;
    return fRet;
}

+ (void)AddRoundRectToPath:(CGContextRef)context withRect:(CGRect)rect withOval:(CGFloat)oval
{
	CGFloat fw, fh, fr;
	if (oval == 0)
	{
		CGContextAddRect(context, rect);
	}	
	else 
	{
		CGContextBeginPath(context);
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextScaleCTM(context, oval, oval);
		fw = CGRectGetWidth(rect)/oval;
		fh = CGRectGetHeight(rect)/oval;
		fr = 0.5;
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, fr);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, fr);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, fr);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, fr);
		CGContextRestoreGState(context);
		CGContextClosePath(context);
	}
}	

+(void)DrawBasePipe:(CGContextRef)context
{
	CGContextSaveGState(context);
    CGFloat width = [CPinRender GetPointerImageWidth];
    CGFloat height = [CPinRender GetPointerImageLength];

    CGFloat innerW = [CPinRender GetPointerImageInnerWidth];
    CGFloat wp = innerW/2.0;
    if([ApplicationConfigure iPADDevice])
        wp = innerW/4.0; 
    CGFloat sx = (width-wp)/2.0;
    //CGRect rect = CGRectMake(sx, 0, innerW, height);
    //[CPinRender AddRoundRectToPath:context withRect:rect withOval:wp];
    CGContextBeginPath(context);
    CGContextSaveGState(context);
	CGContextAddArc(context, width/2.0, height-wp/2, wp/2, 0, M_PI, false);
    CGContextAddLineToPoint(context, sx, innerW/2.0+wp/2);
	CGContextAddArc(context, width/2.0, innerW/2.0+wp/2, wp/2, M_PI, M_PI*2.0,false);
    CGContextAddLineToPoint(context, wp+sx, height-wp/2);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    CGContextClip(context);
  
    CGGradientRef gradientFill;
    CGColorSpaceRef fillColorspace;
    size_t num_locations = 3;
    CGFloat locations[3] = {0.0, 0.5, 1.0};
    CGFloat colors[12] = 
    {
        //0.0, 0.0, 0.0, 1.0,
        //0.95, 0.95, 0.95, 1.0,
        //0.0, 0.0, 0.0, 1.0,
        0.6, 0.3, 0.2, 1.0,
        1.0, 1.0, 1.0, 1.0,
        0.6, 0.3, 0.2, 1.0,
    };
    
    fillColorspace = CGColorSpaceCreateDeviceRGB();
    gradientFill = CGGradientCreateWithColorComponents (fillColorspace, colors, locations, num_locations);
    
    CGPoint pt1, pt2;
    pt1.x = 0;
    pt1.y = 0;
    pt2.x = wp;
    pt2.y = 0;
    CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
    
    CGColorSpaceRelease(fillColorspace);
    CGGradientRelease(gradientFill);
	CGContextRestoreGState(context);
}

+(void)DrawTopStar:(CGContextRef)context
{
    CGImageRef image = [ImageLoader LoadImageWithName:@"star.png"];
	CGContextSaveGState(context);
    CGFloat width = [CPinRender GetPointerImageInnerWidth];
    if([ApplicationConfigure iPhoneDevice])
        width = width*1.6;
    float sx = ([CPinRender GetPointerImageWidth] - width)*0.5;
    CGRect rect = CGRectMake(sx, 0, width, width);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
    CGImageRelease(image);
}

+(void)DrawWings:(CGContextRef)context
{
	CGContextSaveGState(context);
    CGFloat width = [CPinRender GetPointerImageWidth];
    CGFloat height = [CPinRender GetPointerImageLength];

    CGFloat innerWidth = [CPinRender GetPointerImageInnerWidth];
    CGFloat wp = innerWidth/2.0;
    if([ApplicationConfigure iPADDevice])
        wp = innerWidth/4.0; 
    CGFloat sx = (width-wp)/2.0;
    
    //float realh = height-width/2.0;
    float starty = innerWidth/2.0;
    float centery = width; 
    
    CGContextBeginPath(context);
    CGContextSaveGState(context);
	CGContextAddArc(context, width/2.0, height-wp/2, wp/2, 0, M_PI, false);
	CGContextAddQuadCurveToPoint(context, sx, centery, 0, centery);
	CGContextAddQuadCurveToPoint(context, sx, centery, sx, starty);
    CGContextAddArc(context, width/2.0, starty+wp/2, wp/2, M_PI, M_PI*2.0,false);
	CGContextAddQuadCurveToPoint(context, sx+wp, centery, width, centery);
	CGContextAddQuadCurveToPoint(context, sx+wp, centery, sx+wp, height-wp/2);
    CGContextRestoreGState(context);
    CGContextClosePath(context);
   
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextClip(context);
    
    CGGradientRef gradientFill;
    CGColorSpaceRef fillColorspace;
    size_t num_locations = 3;
    CGFloat locations[3] = {0.0, 0.5, 1.0};
    CGFloat colors[12] = 
    {
        //0.1, 0.1, 0.1, 0.5,
        //0.5, 0.5, 0.5, 1.0,
        //0.1, 0.1, 0.1, 0.5,
        0.45, 0.35, 0.07, 1.0,
        0.93, 0.81, 0.0, 1.0,
        0.45, 0.35, 0.07, 1.0,
    };
    
    fillColorspace = CGColorSpaceCreateDeviceRGB();
    gradientFill = CGGradientCreateWithColorComponents (fillColorspace, colors, locations, num_locations);
    
    CGPoint pt1, pt2;
    pt1.x = rect.origin.x;
    pt1.y = rect.origin.y;
    pt2.x = rect.origin.x+rect.size.width;
    pt2.y = rect.origin.y;
    CGContextDrawLinearGradient (context, gradientFill, pt1, pt2, 0);
    
    CGColorSpaceRelease(fillColorspace);
    CGGradientRelease(gradientFill);
	CGContextRestoreGState(context);
}

+(CGImageRef)CreatePointerImage
{
    CGImageRef image;
   
    CGFloat width = [CPinRender GetPointerImageWidth];
    CGFloat height = [CPinRender GetPointerImageLength];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
    [CPinRender DrawWings:bitmapContext];
    [CPinRender DrawTopStar:bitmapContext];
    
    
	image = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return image;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_Pointer = [CPinRender CreatePointerImage];
		CGFloat clrvals[] = {0.0, 0.0, 0.0, 0.6};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(4, 4);
    }
    return self;    
}

-(void)dealloc
{
    CGImageRelease(m_Pointer);
	CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
}

-(void)DrawPointer:(CGContextRef)context at:(CGRect)rect
{
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, m_ShadowSize, 2, m_ShadowClrs);
    CGContextDrawImage(context, rect, m_Pointer);
    CGContextRestoreGState(context);
}

@end
