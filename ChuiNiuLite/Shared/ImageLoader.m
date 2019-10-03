//
//  ImageLoader.m
//  ChuiNiu
//
//  Created by Zhaohui Xing on 2010-08-04.
//  Copyright 2010 xgadget. All rights reserved.
//
#include "libinc.h"
#import "ImageLoader.h"
#import "ApplicationConfigure.h"


#define DEFAULTAPLHA  0.4


#define  BACKGROUND_GRID_SIZE_IPAD   40.0
#define  BACKGROUND_GRID_SIZE_IPHONE 20.0

//static CGImageRef   g_DogJumpImage = NULL;
static CGImageRef   g_BlastImage = NULL;

@implementation ImageLoader

+ (void)LoadDogImages
{
//	NSString *imagePath3 = [[NSBundle mainBundle] pathForResource:@"Jumping.png" ofType:nil];
//	UIImage* orgImagge3 = [UIImage imageWithContentsOfFile:imagePath3];
//	g_DogJumpImage  = CGImageRetain(orgImagge3.CGImage);
	
	NSString *imagePath4 = [[NSBundle mainBundle] pathForResource:@"blast.png" ofType:nil];
	UIImage* orgImagge4 = [UIImage imageWithContentsOfFile:imagePath4];
	g_BlastImage  = CGImageRetain(orgImagge4.CGImage);


}

+ (void)Initialize
{
	[ImageLoader LoadDogImages];	
}

+ (void)Release
{
	if(g_BlastImage)
		CGImageRelease(g_BlastImage);

}	


+ (CGImageRef)LoadCowImage1:(float)width andHeight:(float)height
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cow1.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef   DogImage  = CGImageRetain(orgImagge.CGImage);
	
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, DogImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(DogImage);
	
	return retImage;
}

+ (CGImageRef)LoadCowImage2:(float)width andHeight:(float)height
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cow2.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef   DogImage  = CGImageRetain(orgImagge.CGImage);
	
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, DogImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(DogImage);
	
	return retImage;
}

+ (CGImageRef)LoadCowImage3:(float)width andHeight:(float)height
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cow3.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef   DogImage  = CGImageRetain(orgImagge.CGImage);
	
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, DogImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(DogImage);
	
	return retImage;
}	


+ (CGImageRef)LoadCowImage4:(float)width andHeight:(float)height
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cow4.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef   DogImage  = CGImageRetain(orgImagge.CGImage);
	
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, DogImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(DogImage);
	
	return retImage;
}

+ (CGImageRef)LoadDeadCowImage:(float)width andHeight:(float)height
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"deadcow.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef   DogImage  = CGImageRetain(orgImagge.CGImage);
	
	CGRect rect = CGRectMake(0.0, 0.0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, DogImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	CGImageRelease(DogImage);
	
	return retImage;
}	


+ (CGImageRef)LoadBlastImage:(float)width andHeight:(float)height
{
	float fImageW = CGImageGetWidth(g_BlastImage);
	float fImageH = CGImageGetHeight(g_BlastImage);
	float fRatio = fImageW/fImageH;
	float fR2 = width/height;
	float w, h;
	
	if(fRatio < fR2)
	{
		h = height;
		w = h*fRatio;
	}
	else
	{
		w = width;
		h = w/fRatio;
	}	
	
	
	CGRect rect = CGRectMake(0.0, 0.0, w, h);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, w, h, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGContextDrawImage(bitmapContext, rect, g_BlastImage);
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	return retImage;
}


+ (CGImageRef)CreatClockBackGround:(float)r
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, 2.0*r, 2.0*r, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));

	CGFunctionRef greyFunction;
	CGFunctionRef blackFunction;
	const float clrGrey[3] = {0.6, 0.6, 0.6};
	const float clrGreyLit[3] = {0.3, 0.3, 0.3};
	const float clrBlack[3] = {0.5, 0.5, 0.5};
	const float clrBlackLit[3] = {0.05, 0.05, 0.05};
	greyFunction = CreateSadingFunctionWithColors(clrGrey, clrGreyLit);
	blackFunction = CreateSadingFunctionWithColors(clrBlack, clrBlackLit);
    CGPoint innerCircleCenter, outterCircleCenter;
	float   innerCircleRadius, outterCircleRadius;
	bool    extendStart, extendEnd;
	
	outterCircleRadius = r;
	innerCircleRadius = r*0.75;
	outterCircleCenter = CGPointMake(r, r);  //CGPointZero;
	innerCircleCenter = CGPointMake(r, r);//CGPointMake(r*0.25, r*0.25);
	extendStart = extendEnd = false;
	CGShadingRef shading = CGShadingCreateRadial(colorSpace, innerCircleCenter, innerCircleRadius, outterCircleCenter, outterCircleRadius,greyFunction,
												 extendStart,extendEnd);
	CGContextDrawShading(bitmapContext,shading);
	CGShadingRelease(shading);

	outterCircleRadius = r*0.75;
	innerCircleRadius = 0;
	shading = CGShadingCreateRadial(colorSpace, innerCircleCenter, innerCircleRadius, outterCircleCenter, outterCircleRadius,blackFunction,
												 extendStart,extendEnd);
	CGContextDrawShading(bitmapContext,shading);
	
    
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	
	CGFunctionRelease(greyFunction);
	CGFunctionRelease(blackFunction);
	CGShadingRelease(shading);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);

	return retImage;
}	

+ (CGImageRef)LoadRainBowImage
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"rainbow.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}	

+ (CGImageRef)LoadCloudImage1
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cloud1.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}

+ (CGImageRef)LoadCloudImage2
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cloud2.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}	

+ (CGImageRef)LoadRainImage1
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"rain1.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}

+ (CGImageRef)LoadRainImage2
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"rain2.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}

+ (CGImageRef)LoadLightImage1
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"light1.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}

+ (CGImageRef)LoadLightImage2
{
	CGImageRef   pImage = NULL;
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"light2.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	pImage  = CGImageRetain(orgImagge.CGImage);
	return pImage;
}

+ (CGImageRef)CreateLandScapeBKImage
{
	float w, h, sx, sy, step;
	int nStrok;
	float clr = 0.75;
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
	float clr = 0.75;
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
	
	w = [CGameLayout GetGameSceneDeviceWidth];
	h = [CGameLayout GetGameSceneDeviceHeight];
	
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

+ (void)DrawMoon:(CGContextRef)context at:(CGRect)rect
{
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"moon.png" ofType:nil];
	UIImage* orgImagge = [UIImage imageWithContentsOfFile:imagePath];
	CGImageRef image = CGImageRetain(orgImagge.CGImage);

	float clrvals[] = {0.9, 0.9, 0.9, 1.0f};
	CGColorSpaceRef shadowClrSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
	CGSize shadowSize = CGSizeMake(3, 0);
	
	CGContextSetShadowWithColor(context, shadowSize, 3, shadowClrs);
	CGContextDrawImage(context, rect, image);
	CGImageRelease(image);
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
}	


+ (CGImageRef)CreateLandScapeNightImage
{
	float w, h, sx, sy, step;
	int nStrok;
	float clr = 0.7;
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
    CGContextSetRGBFillColor(bitmapContext, 0.05, 0.05, 0.1, 1.0);
    CGContextFillRect(bitmapContext, rect);
	CGColorSpaceRelease(colorSpace);
	
	CGPatternRef pattern1 = [ImageLoader CreateImageFillPattern:@"star.png" withWidth:w/8 withHeight:w/8 isFlipped:NO];
	CGPatternRef pattern2 = [ImageLoader CreateImageFillPattern:@"star2.png" withWidth:w/8 withHeight:w/8 isFlipped:NO];
    colorSpace = CGColorSpaceCreatePattern(NULL);
	
	CGContextSetFillColorSpace(bitmapContext, colorSpace);
    CGColorSpaceRelease(colorSpace);
	
	CGFloat fAlpha = 0.2;
    CGContextSetFillPattern(bitmapContext, pattern1, &fAlpha);
	CGContextFillRect (bitmapContext, CGRectMake(0, 0, w*0.25, h*0.25));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.3, h*0.02, w*0.44, h*0.35));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.8, h*0.01, w*0.25, h*0.3));	
	
	CGContextFillRect (bitmapContext, CGRectMake(0.0, h*0.35, w*0.25, h*0.25));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.4, h*0.35, w*0.35, h*0.2));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.6, h*0.25, w*0.25, h*0.2));	
	
    CGContextSetFillPattern(bitmapContext, pattern2, &fAlpha);
	CGContextFillRect (bitmapContext, CGRectMake(w*0.22, 0, w*0.28,h*0.25));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.5, h*0.05, w*0.3, h*0.35));	
	CGContextFillRect (bitmapContext, CGRectMake(0*8, 0, w*0.25, h*0.25));

	CGContextFillRect (bitmapContext, CGRectMake(w*0.25, h*0.2, w*0.34, h*0.3));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.55, h*0.2, w*0.3, h*0.3));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.8, h*0.3, w*0.25, h*0.25));
	
	//CGContextFillRect (bitmapContext, CGRectMake(0, 0, w, h/2));	
	CGPatternRelease(pattern1);
	CGPatternRelease(pattern2);

	float mh = h/12;
	float mw = mh*0.66;
	
	rect = CGRectMake(w*0.2, h*0.1, mw, mh);
	
	[ImageLoader DrawMoon:bitmapContext at:rect];
	
	
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	
	return retImage;
}

+ (CGImageRef)CreateProtraitNightImage
{
	float w, h, sx, sy, step;
	int nStrok;
	float clr = 0.7;
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
    CGContextSetRGBFillColor(bitmapContext, 0.05, 0.05, 0.1, 1.0);
    CGContextFillRect(bitmapContext, rect);
	CGColorSpaceRelease(colorSpace);

	CGPatternRef pattern1 = [ImageLoader CreateImageFillPattern:@"star.png" withWidth:w/4 withHeight:w/4 isFlipped:NO];
	CGPatternRef pattern2 = [ImageLoader CreateImageFillPattern:@"star2.png" withWidth:w/4 withHeight:w/4 isFlipped:NO];
    colorSpace = CGColorSpaceCreatePattern(NULL);
	
	CGContextSetFillColorSpace(bitmapContext, colorSpace);
    CGColorSpaceRelease(colorSpace);
	
	CGFloat fAlpha = 0.2;
    CGContextSetFillPattern(bitmapContext, pattern1, &fAlpha);
	CGContextFillRect (bitmapContext, CGRectMake(0, 0, w*0.33, h*0.15));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.4, h*0.1, w*0.33, h*0.33));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.5, h*0.15, w*0.56, h*0.35));	
    CGContextSetFillPattern(bitmapContext, pattern2, &fAlpha);
	CGContextFillRect (bitmapContext, CGRectMake(w*0.6, 0, w*0.4, h*0.15));	
	CGContextFillRect (bitmapContext, CGRectMake(0.0, h*0.25, w*0.35, h*0.25));	
	CGContextFillRect (bitmapContext, CGRectMake(w*0.75, h*0.15, w*0.25, h*0.35));	
	CGPatternRelease(pattern1);
	CGPatternRelease(pattern2);
	
	float mh = h/12;
	float mw = mh*0.66;
	
	rect = CGRectMake(w*0.09, h*0.09, mw, mh);
	
	[ImageLoader DrawMoon:bitmapContext at:rect];
	
	
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	
	return retImage;
}	

+ (UIColor*)GetDefaultViewBackgroundColor
{
	return [UIColor whiteColor];
}

+ (float)GetDefaultViewFillAlpha
{
	return 0.15;
}	

+(CGImageRef)LoadImageWithName:(NSString*)imageName
{
	CGImageRef cgImage;
	
	UIImage* uiImagge = [UIImage imageNamed:imageName];
	
	if(uiImagge != nil)
		cgImage = CGImageRetain(uiImagge.CGImage);
	
	return cgImage;
}

@end
