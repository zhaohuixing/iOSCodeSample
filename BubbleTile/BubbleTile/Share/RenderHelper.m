//
//  RenderHelper.m
//  XXXXXXXXXXXXX
//
//  Created by Zhaohui Xing on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "RenderHelper.h"
#import "ImageLoader.h"
#import "GameConfiguration.h"
#include "drawhelper.h"

static CGImageRef          m_RedBubble;
static CGImageRef          m_StarBubble;
static CGImageRef          m_FrogBubble = NULL;
static CGImageRef          m_FrogMotionBubble = NULL;
static CGImageRef          m_HeartBubble = NULL;
static CGImageRef          m_HeartMotionBubble = NULL;
static CGImageRef          m_HeartMotionBubble2 = NULL;

static CGImageRef          m_RedHeartBubble = NULL; 
static CGImageRef          m_BlueBubble = NULL; 


static CGImageRef          m_QImage = NULL;
static CGImageRef          m_RedQImage = NULL;

static CGImageRef          m_GreenLED;
static CGImageRef          m_RedLED;


static CGPatternRef        m_BkgndPattern;
static CGPatternRef        m_GreenBkgndPattern;
static CGColorSpaceRef     m_PatternSpace;
static CGColorSpaceRef     m_Colorspace;

//static CGImageRef          m_BoardImage = NULL;
//static CGColorRef		   m_BoardShadowClrs;


/*
static CGImageRef          m_AvatarIdle[3];
static CGImageRef          m_AvatarPlay[3];
static CGImageRef          m_AvatarWin[3];
static CGImageRef          m_AvatarCry[3];

static CGImageRef          m_MeIdle[3];
static CGImageRef          m_MePlay[3];
static CGImageRef          m_MeWin[3];
static CGImageRef          m_MeCry[3];

static CGImageRef          m_LuckSignBackgroundImage;
static CGImageRef          m_BetSignBackgroundImage;
static CGImageRef          m_RedStarImage; 
static CGImageRef          m_CashImage; 
static CGImageRef          m_CrossImage; 
static CGImageRef          m_CashOctagonImage;
static CGImageRef          m_CashEarnIconMe;
static CGImageRef          m_CashEarnIconOther;
static CGImageRef          m_DisableCashEarnIconMe;
static CGImageRef          m_DisableCashEarnIconOther;


static CGPatternRef        m_BkgndPattern;

static CGImageRef          m_OnLineGroupIcon;
static CGImageRef          m_EnableSignIcon;
static CGImageRef          m_DisableSignIcon;
static CGImageRef          m_GreenQmark;
static CGImageRef          m_YellowQmark;


static CGGradientRef       m_BlueGradient;
static CGColorSpaceRef     m_BlueColorspace;

static CGGradientRef       m_HighLightGradient;
static CGColorSpaceRef     m_HighLightColorspace;
*/

@implementation RenderHelper

+(CGImageRef)CreateBoardImage
{
    CGImageRef pFrameImage = [ImageLoader LoadResourceImage:@"woodframe.png"];
    CGImageRef pBaseImage = [ImageLoader LoadResourceImage:@"woodbase.png"];
    float fFrameWidth = CGImageGetWidth(pFrameImage);
    float fFrameHeight = CGImageGetHeight(pFrameImage);
    float fBaseWidth = CGImageGetWidth(pBaseImage);
    float fBaseHeight = CGImageGetHeight(pBaseImage);   
    
    float cx = fFrameWidth*0.5;
    float cy = fFrameHeight*0.5;
    CGRect baseRect = CGRectMake(cx-fBaseWidth*0.5 , cy-fBaseHeight*0.5, fBaseWidth, fBaseHeight);
    CGRect frameRect = CGRectMake(0.0, 0.0, fFrameWidth, fFrameHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, fFrameWidth, fFrameHeight, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
    CGContextDrawImage(bitmapContext, baseRect, pBaseImage);
    
    CGContextSetLineWidth(bitmapContext, 2);
    CGContextSetRGBStrokeColor(bitmapContext, 0.3, 0.1, 0.1, 0.8);
    CGPoint pt1 = CGPointMake(cx-fBaseWidth*0.5+1, cy+fBaseHeight*0.5-1);
    CGPoint pt2 = CGPointMake(cx+fBaseWidth*0.5-1, cy+fBaseHeight*0.5-1);
    CGPoint pt3 = CGPointMake(cx+fBaseWidth*0.5-1, cy-fBaseHeight*0.5+1);
    DrawLine1(bitmapContext, pt1, pt2);
    DrawLine1(bitmapContext, pt2, pt3);
    
    CGColorSpaceRef		shadowClrSpace;
    CGColorRef			shadowClrs;
    CGSize				shadowSize;
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowSize = CGSizeMake(5, 5);
    float clrvals[] = {0.3, 0.2, 0.2, 0.8};
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    CGContextSetShadowWithColor(bitmapContext, shadowSize, 5, shadowClrs);
    
	CGContextDrawImage(bitmapContext, frameRect, pFrameImage);
    
    CGContextSetRGBStrokeColor(bitmapContext, 0.2, 0.1, 0.1, 0.5);
    pt1 = CGPointMake(1, 1);
    pt2 = CGPointMake(fFrameWidth-1, 1);
    pt3 = CGPointMake(fFrameWidth-1, fFrameHeight-1);
    CGPoint pt4 = CGPointMake(1, fFrameHeight-1);
    DrawLine1(bitmapContext, pt1, pt2);
    DrawLine1(bitmapContext, pt2, pt3);
    DrawLine1(bitmapContext, pt3, pt4);
    DrawLine1(bitmapContext, pt4, pt1);
    
    
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    CGContextRestoreGState(bitmapContext);
    
	CGImageRef retImage = CGBitmapContextCreateImage(bitmapContext);
    CGImageRelease(pFrameImage);
    CGImageRelease(pBaseImage);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
    
    return retImage;
}

+(void)InitializeResource
{
    m_RedBubble = [ImageLoader LoadImageWithName:@"bubble.png"];
    m_StarBubble = [ImageLoader LoadImageWithName:@"sbubble.png"];
    if([GameConfiguration IsValentineDay])
    {
        m_HeartBubble = [ImageLoader LoadImageWithName:@"heartball1.png"];
        m_HeartMotionBubble = [ImageLoader LoadImageWithName:@"heartball2.png"];
        m_HeartMotionBubble2 = [ImageLoader LoadImageWithName:@"heartball2B.png"];
        m_QImage = [ImageLoader LoadResourceImage:@"heartmark.png"];
        m_RedQImage = [ImageLoader LoadResourceImage:@"heartmark.png"]; 
        m_FrogBubble = NULL;
        m_FrogMotionBubble = NULL;
    }
    else 
    {
        m_HeartBubble = NULL;
        m_HeartMotionBubble = NULL;
        m_HeartMotionBubble2 = NULL;
        m_FrogBubble = [ImageLoader LoadImageWithName:@"frogicon1.png"];
        m_FrogMotionBubble = [ImageLoader LoadImageWithName:@"frogicon2.png"];
        m_QImage = [ImageLoader LoadResourceImage:@"qmark.png"];
        m_RedQImage = [ImageLoader LoadResourceImage:@"rqmark.png"]; 
    }

    m_RedHeartBubble = [ImageLoader LoadImageWithName:@"rbubble.png"]; 
    m_BlueBubble = [ImageLoader LoadImageWithName:@"bbubble.png"]; 
    
    
    m_GreenLED = [ImageLoader LoadResourceImage:@"gled.png"];
    m_RedLED = [ImageLoader LoadResourceImage:@"rled.png"];
	
    CGAffineTransform transform;
    CGPatternCallbacks callbacks;
	callbacks.version = 0;
	callbacks.drawPattern = &DrawPatternImage;
	callbacks.releaseInfo = &ReleasePatternImage;
    
	CGImageRef image = [ImageLoader LoadImageWithName:@"bktex.png"];
	
	float width = CGImageGetWidth(image);
	float height = CGImageGetHeight(image);
	
	transform = CGAffineTransformIdentity;
    
    
	m_BkgndPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);

    
	image = [ImageLoader LoadImageWithName:@"greentex2.png"];
	width = CGImageGetWidth(image);
	height = CGImageGetHeight(image);
	m_GreenBkgndPattern = CGPatternCreate(image, CGRectMake(0, 0, width, height), transform, width, height,kCGPatternTilingNoDistortion, true, &callbacks);
    
    m_PatternSpace = CGColorSpaceCreatePattern(NULL);
    m_Colorspace = CGColorSpaceCreateDeviceRGB();
    
//    m_BoardImage = [RenderHelper CreateBoardImage];
//    float clrvals[] = {0.2, 0.1, 0.1, 1.0};
//    m_BoardShadowClrs = CGColorCreate(m_Colorspace, clrvals);
}

+(void)ReleaseResource
{
    CGImageRelease(m_RedBubble);
    CGImageRelease(m_StarBubble);
   
    CGImageRelease(m_RedHeartBubble); 
    CGImageRelease(m_BlueBubble); 
    
    if(m_FrogBubble != NULL)
        CGImageRelease(m_FrogBubble);
    
    if(m_FrogMotionBubble != NULL)
        CGImageRelease(m_FrogMotionBubble);
    
    if(m_HeartBubble != NULL)
        CGImageRelease(m_HeartBubble);
    
    if(m_HeartMotionBubble != NULL)
        CGImageRelease(m_HeartMotionBubble);
    
    if(m_HeartMotionBubble2 != NULL)
        CGImageRelease(m_HeartMotionBubble2);
  
    CGImageRelease(m_QImage);
    
    CGImageRelease(m_GreenLED);
    CGImageRelease(m_RedLED);
    CGPatternRelease(m_BkgndPattern);
    CGPatternRelease(m_GreenBkgndPattern);
    CGColorSpaceRelease(m_PatternSpace);
    CGColorSpaceRelease(m_Colorspace);
    
//    CGColorRelease(m_BoardShadowClrs);
//    CGImageRelease(m_BoardImage);
    CGImageRelease(m_RedQImage);
}

+(void)DefaultPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_BkgndPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
    CGContextSaveGState(context);
    float colors[4] = {1, 0.6, 0.6, 0.4};
    CGContextSetFillColorSpace(context, m_Colorspace);
	CGContextSetFillColor(context, colors);
	CGContextFillRect(context, rect);
	CGContextRestoreGState(context);
    
}

+(void)DrawGreenPatternFill:(CGContextRef)context withAlpha:(float)fAlpha atRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetFillColorSpace(context, m_PatternSpace);
    CGContextSetFillPattern(context, m_GreenBkgndPattern, &fAlpha);
	CGContextFillRect (context, rect);	
	CGContextRestoreGState(context);
}

+(float)GetBubbleImageWidth
{
    return CGImageGetWidth(m_RedBubble);
}

+(float)GetBubbleImageHeight
{
    return CGImageGetHeight(m_RedBubble);
}

+(void)DrawRedBubble:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RedBubble); 
}

+(void)DrawStarBubble:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_StarBubble); 
}

+(void)DrawFrogBubble:(CGContextRef)context at:(CGRect)rect
{
    if([GameConfiguration IsValentineDay])
    {
        CGContextDrawImage(context, rect, m_HeartBubble); 
    }
    else
    {    
        CGContextDrawImage(context, rect, m_FrogBubble); 
    }    
}

+(void)DrawFrogMotionBubble:(CGContextRef)context at:(CGRect)rect
{
    if([GameConfiguration IsValentineDay])
    {
        if([GameConfiguration IsOddState])
            CGContextDrawImage(context, rect, m_HeartMotionBubble); 
        else
            CGContextDrawImage(context, rect, m_HeartMotionBubble2); 
    }
    else
    {    
        CGContextDrawImage(context, rect, m_FrogMotionBubble); 
    }    
}

+(void)DrawHeartBubble:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RedHeartBubble); 
}

+(void)DrawBlueBubble:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_BlueBubble); 
}

+(void)DrawBoard:(CGContextRef)context at:(CGRect)rect
{
/*    CGContextSaveGState(context);
    CGSize				shadowSize;
    CGContextSetShadowWithColor(context, shadowSize, 6, m_BoardShadowClrs);
    CGContextDrawImage(context, rect, m_BoardImage);
    CGContextRestoreGState(context);*/
}

+(void)DrawRedIndicator:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_RedLED);
}

+(void)DrawGreenIndicator:(CGContextRef)context at:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_GreenLED);
}

+(void)DrawQmark:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextDrawImage(context, rect, m_QImage);
    CGContextRestoreGState(context);
}

+(void)DrawRedQmark:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextDrawImage(context, rect, m_RedQImage);
    CGContextRestoreGState(context);
}

+(CGImageRef)GetPlayHelpMarkImage:(int)enBubbleType
{
    CGImageRef retImage = NULL;
    float srcWidth = [RenderHelper GetBubbleImageWidth];
    float srcHeight = [RenderHelper GetBubbleImageHeight];
    float numImageWidth = CGImageGetWidth(m_QImage);
    float numImageHeight = CGImageGetHeight(m_QImage);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGContextRef bitmapContext = CGBitmapContextCreate(nil, srcWidth, srcHeight, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
    CGRect rect = CGRectMake(0.0, 0.0, srcWidth, srcHeight);
    if(enBubbleType == PUZZLE_BUBBLE_STAR)
    {
        [RenderHelper DrawStarBubble:bitmapContext at:rect];
    }
    else if(enBubbleType == PUZZLE_BUBBLE_FROG)
    {
        //[RenderHelper DrawFrogBubble:bitmapContext at:rect];
        [RenderHelper DrawFrogMotionBubble:bitmapContext at:rect];
    }
    else if(enBubbleType == PUZZLE_BUBBLE_REDHEART)
    {
        [RenderHelper DrawHeartBubble:bitmapContext at:rect];
    }
    else if(enBubbleType == PUZZLE_BUBBLE_BLUE)
    {    
        [RenderHelper DrawBlueBubble:bitmapContext at:rect];
    }
    else
    {    
        [RenderHelper DrawRedBubble:bitmapContext at:rect];
    }    
    float cx = srcWidth/2;
    float cy = srcHeight/2;
    rect = CGRectMake(cx-numImageWidth/2, cy-numImageHeight/2, numImageWidth, numImageHeight);
    if(enBubbleType == PUZZLE_BUBBLE_BLUE)
        [RenderHelper DrawRedQmark:bitmapContext inRect:rect];
    else         
        [RenderHelper DrawQmark:bitmapContext inRect:rect];
    CGContextRestoreGState(bitmapContext);
    
	retImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    return retImage;    
}

@end
