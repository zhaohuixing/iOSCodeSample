//
//  BubbleObject.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include "stdinc.h"
#import "BubbleObject.h"
#import "ImageLoader.h"
#import "GameConfiguration.h"
#import "RenderHelper.h"

@implementation BubbleObject

@synthesize m_nCurrentLocationIndex;

-(void)CreateBubbleImage:(int)nLabel
{
    float srcWidth = [RenderHelper GetBubbleImageWidth];
    float srcHeight = [RenderHelper GetBubbleImageHeight];
    float fRatio = 0.54;
    float numImageWidth = srcWidth*fRatio;
    float numImageHeight = srcHeight*fRatio;
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef numericContext = CGBitmapContextCreate(nil, numImageWidth, numImageHeight, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(numericContext);
    CGRect numRect = CGRectMake(0.0, 0.0, numImageWidth, numImageHeight);
    [ImageLoader DrawNumber:numericContext withNumber:nLabel inRect:numRect];
///???
//??    [RenderHelper DrawFrogMotionBubble:numericContext at:CGRectMake(0, 0, numImageWidth, numImageWidth)];
//??      [RenderHelper DrawStarBubble:numericContext at:CGRectMake(0, 0, numImageWidth, numImageWidth)];
///???
    CGContextRestoreGState(numericContext);
    
	CGImageRef numImage = CGBitmapContextCreateImage(numericContext);
	CGContextRelease(numericContext);

	CGContextRef bitmapContext = CGBitmapContextCreate(nil, srcWidth, srcHeight, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextSaveGState(bitmapContext);
    CGRect rect = CGRectMake(0.0, 0.0, srcWidth, srcHeight);
    if(m_BubbleType == PUZZLE_BUBBLE_STAR)
    {
        [RenderHelper DrawStarBubble:bitmapContext at:rect];
    }
    else if(m_BubbleType == PUZZLE_BUBBLE_FROG)
    {
        [RenderHelper DrawFrogBubble:bitmapContext at:rect];
    }
	else if(m_BubbleType == PUZZLE_BUBBLE_REDHEART)
	{
        [RenderHelper DrawHeartBubble:bitmapContext at:rect];
    }
    else if(m_BubbleType == PUZZLE_BUBBLE_BLUE)
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
    CGContextDrawImage(bitmapContext, rect, numImage);
    
    ///???
    //rect = CGRectMake(cx-numImageWidth/2, (srcHeight-numImageWidth)/2.0, numImageWidth, numImageWidth);
    //CGContextDrawImage(bitmapContext, rect, numImage);
    ///???
    CGContextRestoreGState(bitmapContext);
    
	m_Bubble = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(numImage);
}

-(void)SetIconTemplate:(BOOL)bIcon
{
    m_bIconTemplate = bIcon;
}

-(id)init:(enBubbleType)bType
{
    if((self = [super init]))
    {
        m_nCurrentLocationIndex = -1;
        m_Bubble = NULL;    
        m_bIconTemplate = NO;
        m_nLabelValue = -1;
        m_bShowQmark = NO;
        m_BubbleType = bType;
    }
    return self;
}

-(id)initBubble:(int)nLabel isTemplate:(BOOL)bNo withType:(enBubbleType)bType
{
    if((self = [super init]))
    {
        m_nCurrentLocationIndex = -1;
        m_bIconTemplate = bNo;
        m_nLabelValue = nLabel;
        m_BubbleType = bType; 
        [self CreateBubbleImage:nLabel];    
    }
    return self;
}

-(void)SetLabel:(int)nLabel
{
    if(m_Bubble != NULL)
        CGImageRelease(m_Bubble);

    m_nLabelValue = nLabel;
    [self CreateBubbleImage:nLabel];    
}

-(void)dealloc
{
    if(m_Bubble != NULL)
        CGImageRelease(m_Bubble);
    
    [super dealloc];
}

-(void)DrawBubble:(CGContextRef)context inRect:(CGRect)rect inMotion:(BOOL)bMotion
{
    CGContextSaveGState(context); 
    
    CGColorSpaceRef		shadowClrSpace;
    CGColorRef			shadowClrs;
    CGSize				shadowSize;
    shadowClrSpace = CGColorSpaceCreateDeviceRGB();
    shadowSize = CGSizeMake(2.5, 2.5);
    float clrvals[] = {0.1, 0.1, 0.1, 0.8};
    shadowClrs = CGColorCreate(shadowClrSpace, clrvals);
    
    
    CGContextSetShadowWithColor(context, shadowSize, 2.5, shadowClrs);
    
    if(bMotion && [GameConfiguration GetBubbleType] == PUZZLE_BUBBLE_FROG)
        [RenderHelper DrawFrogMotionBubble:context at:rect];
    else    
        CGContextDrawImage(context, rect, m_Bubble);
    if(m_bShowQmark)
    {
        float fSize = rect.size.width*0.25;
        float sx = rect.origin.x + rect.size.width*0.5-fSize*0.5;
        float sy = rect.origin.y;
        CGRect qrect = CGRectMake(sx, sy, fSize, fSize);
        if(m_BubbleType == PUZZLE_BUBBLE_BLUE)
            [RenderHelper DrawRedQmark:context inRect:qrect];
        else
            [RenderHelper DrawQmark:context inRect:qrect];
    }
   
	CGColorSpaceRelease(shadowClrSpace);
	CGColorRelease(shadowClrs);
    CGContextRestoreGState(context);
}

-(int)GetLabelValue
{
    return m_nLabelValue;
}

-(void)SetQMark:(BOOL)bShow
{
    m_bShowQmark = bShow;
}


@end
