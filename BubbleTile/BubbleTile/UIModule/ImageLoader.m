//
//  ImageLoader.m
//  XXXXX
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 xgadget. All rights reserved.
//
#import "ImageLoader.h"
#import "ApplicationConfigure.h"
#import "GUILayout.h"
#include "drawhelper.h"


#define DEFAULTAPLHA  0.4

#define  BACKGROUND_GRID_SIZE_IPAD   40.0
#define  BACKGROUND_GRID_SIZE_IPHONE 20.0


@implementation ImageLoader

+ (void)Initialize
{
}

+ (void)Release
{
}	

+ (CGImageRef)CreateLandScapeBKImage
{
	float w, h, sx, sy, step;
	int nStrok;
	float clr = 0.9;
	if([ApplicationConfigure iPADDevice])
	{
		w = 1024;//GAME_SCREEN_VIEW_X_L_IPAD;
		h = 748;//GAME_SCREEN_VIEW_Y_L_IPAD;
	    sx = 1.0;
	    sy = 1.0;
		nStrok = 2;
		step = BACKGROUND_GRID_SIZE_IPAD;
		clr = 0.8;
	}
	else
	{
		w = 480;//GAME_SCREEN_VIEW_X_L_IPHONE;
		h = 300;//GAME_SCREEN_VIEW_Y_L_IPHONE;
	    sx = 1.0;
	    sy = 1.0;
		nStrok = 1;
		step = BACKGROUND_GRID_SIZE_IPHONE;
	}	

	CGRect rect = CGRectMake(0.0, 0.0, w, h);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGContextSetRGBFillColor(bitmapContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(bitmapContext, rect);
	
	CGContextSetRGBFillColor(bitmapContext, clr, clr, clr, 1.0);
	sx = 1.0;
	for(int i = 0; sx <= w;  ++i)
	{
		sy = 1.0;
		for(int j = 0; sy <= h; ++j)
		{
			if(i%2 == 0)
			{
				if(j%2 == 1)
				{
					rect = CGRectMake(sx, sy, step, step);
					CGContextFillRect(bitmapContext, rect);
				}	
			}
			else 
			{
				if(j%2 == 0)
				{
					rect = CGRectMake(sx, sy, step, step);
					CGContextFillRect(bitmapContext, rect);
				}	
			}

			sy += step;
		}	
		
		sx += step;
	}	
	
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return retImage;
}

+ (CGImageRef)CreateProtraitBKImage
{
	float w, h, sx, sy, step;
	int nStrok;
	float clr = 0.9;
	if([ApplicationConfigure iPADDevice])
	{
		w = 768;//GAME_SCREEN_VIEW_X_P_IPAD;
		h = 1004;//GAME_SCREEN_VIEW_Y_P_IPAD;
	    sx = 1.0;
	    sy = 1.0;
		nStrok = 2;
		step = BACKGROUND_GRID_SIZE_IPAD;
		clr = 0.8;
	}
	else
	{
		w = 320;//GAME_SCREEN_VIEW_X_P_IPHONE;
		h = 460;//GAME_SCREEN_VIEW_Y_P_IPHONE;
	    sx = 1.0;
	    sy = 1.0;
		nStrok = 1;
		step = BACKGROUND_GRID_SIZE_IPHONE;
	}	
	
	CGRect rect = CGRectMake(0.0, 0.0, w, h);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGContextSetRGBFillColor(bitmapContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(bitmapContext, rect);
	
	CGContextSetRGBFillColor(bitmapContext, clr, clr, clr, 1.0);
	sx = 1.0;
	for(int i = 0; sx <= w;  ++i)
	{
		sy = 1.0;
		for(int j = 0; sy <= h; ++j)
		{
			if(i%2 == 0)
			{
				if(j%2 == 1)
				{
					rect = CGRectMake(sx, sy, step, step);
					CGContextFillRect(bitmapContext, rect);
				}	
			}
			else 
			{
				if(j%2 == 0)
				{
					rect = CGRectMake(sx, sy, step, step);
					CGContextFillRect(bitmapContext, rect);
				}	
			}
			
			sy += step;
		}	
		
		sx += step;
	}	
	
	
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return retImage;
}	

+ (CGImageRef)CreatePaperBkgndImage
{
	float w, h, sx, sy, step;
	int nStrok;
	float clr = 0.7;
	if([ApplicationConfigure iPADDevice])
	{
	    sx = 1.0;
	    sy = 1.0;
		nStrok = 2;
		step = BACKGROUND_GRID_SIZE_IPAD;
		clr = 0.8;
	}
	else
	{
	    sx = 1.0;
	    sy = 1.0;
		nStrok = 1;
		step = BACKGROUND_GRID_SIZE_IPHONE;
	}	
	
	w = 1024;//[CGameLayout GetGameSceneDeviceWidth];
	h = 768;//[CGameLayout GetGameSceneDeviceHeight];
	
	CGRect rect = CGRectMake(0.0, 0.0, w, h);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGContextSetRGBFillColor(bitmapContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(bitmapContext, rect);
	
	CGContextSetLineWidth(bitmapContext, nStrok);
	CGContextSetRGBStrokeColor(bitmapContext, clr, clr, clr, 1.0);
	
	int i;
	for(i = 0; sx <= w;  ++i)
	{
		DrawLine2(bitmapContext, sx, sy, sx, h);
		sx += step;
	}	
	
	sx = 1.0;
	for(i = 0; sy <= h; ++i)
	{
		DrawLine2(bitmapContext, sx, sy, w, sy);
		sy += step;
	}	
	
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return retImage;
}	


+ (CGImageRef)CreateTextImage:(NSString*)szText
{
	float w = 200;
	float h = 200;
	CGRect rect = CGRectMake(0.0, 0.0, w, h);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	float fFontSize = 32;
	float fCharspce = 2;
	const char *pText = [szText UTF8String];
	int nLength = strlen(pText);
	CGPoint pt;
	CGContextSaveGState(bitmapContext);
	CGContextSetRGBStrokeColor(bitmapContext, 1, 0, 0, 1);
	CGContextSelectFont(bitmapContext, "Zapfino",  fFontSize, kCGEncodingMacRoman);
	CGContextSetCharacterSpacing(bitmapContext, fCharspce);
	CGContextSetTextDrawingMode(bitmapContext, kCGTextFillStroke);
	CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(bitmapContext, xform);
	CGContextShowTextAtPoint(bitmapContext, 0, 0, pText, nLength);
	pt = CGContextGetTextPosition(bitmapContext);
	CGContextRestoreGState(bitmapContext);

	CGImageRef srcImage = CGBitmapContextCreateImage(bitmapContext);
	if(pt.y == 0.0)
		pt.y = fFontSize;
	
	rect = CGRectMake(0.0, 0.0, pt.x, pt.y);
	CGImageRef retImage = CGImageCreateWithImageInRect(srcImage, rect);
   	
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(srcImage);
	
	return retImage;
	
}	

+ (CGPatternRef)CreateImageFillPattern:(NSString*)file withWidth:(float)w withHeight:(float)h isFlipped:(BOOL)bFlipped
{
	CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:file ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef image = CGImageRetain(orgImagge.CGImage);

	float width = CGImageGetWidth(image);
	float height = CGImageGetHeight(image);
	
	float xscale = w/width;
	float yscale = h/width;
	
	if(bFlipped)
		yscale *= -1.0;
	
	transform = CGAffineTransformMakeScale(xscale, yscale);
	
	CGPatternRef pattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
	return pattern;
}	

+ (UIColor*)GetDefaultViewBackgroundColor
{
	//return [UIColor whiteColor];
	return [UIColor clearColor];
}

+ (float)GetDefaultViewFillAlpha
{
	return 0.15;
}	

+(CGImageRef)LoadResourceImage:(NSString*)imageName
{
	CGImageRef cgImage;
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
	UIImage* uiImagge = [UIImage imageWithContentsOfFile:imagePath];
	
	if(uiImagge != nil)
		cgImage = CGImageRetain(uiImagge.CGImage);
	
	return cgImage;
}	

+(CGImageRef)LoadImageWithName:(NSString*)imageName
{
	CGImageRef cgImage;
	
	UIImage* uiImagge = [UIImage imageNamed:imageName];
	
	if(uiImagge != nil)
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
    CGImageRelease(srcImage);
	return retImage;
}

+ (void)DrawNumber:(CGContextRef)context withNumber:(int)value inRect:(CGRect)rect
{
	NSNumber* nsValue = [NSNumber numberWithInt: value];
	NSString* sNumber = [nsValue stringValue];
	const char *sText = [sNumber UTF8String];
	if(sText == NULL)
		return;
	
	CGImageRef imgNumber = CreateNumericImage(sText);
	if(imgNumber == NULL)
		return;
	
	float imgWidth = CGImageGetWidth(imgNumber);
	float imgHeight = CGImageGetHeight(imgNumber);
	float maxWidth = rect.size.width;
	float maxHeight = rect.size.height;
	float width, height;
	height = maxHeight;
	width = height*imgWidth/imgHeight;
	
	if(maxWidth < width)
		width = maxWidth;
    
	CGContextSaveGState(context);
	
	float sx = (rect.size.width - width)/2.0;
	float sy = (rect.size.height - height)/2.0;
	
	CGRect imgRect = CGRectMake(sx, sy, width, height);
	
	CGColorSpaceRef		shadowClrSpace;
	CGColorRef			shadowClrs;
	CGSize				shadowSize;
	shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	shadowSize = CGSizeMake(4, 0);
	float clrvals[] = {0.3, 0.3, 0.3, 1};
	shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
	CGContextSetShadowWithColor(context, shadowSize, 6.0, shadowClrs);
	
	CGContextDrawImage(context, imgRect, imgNumber);
	
	CGImageRelease(imgNumber);
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
	
	CGContextRestoreGState(context);
}	

@end
