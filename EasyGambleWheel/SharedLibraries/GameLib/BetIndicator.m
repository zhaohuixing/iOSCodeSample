//
//  BetIndicator.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BetIndicator.h"
#import "ApplicationConfigure.h"
#import "ImageLoader.h"
#import "RenderHelper.h"
#import "GameConstants.h"
#include "drawhelper.h"

#define REAL_INDICATOR_SIZE_IPHONE              36
#define REAL_INDICATOR_SIZE_IPAD                50  //72

#define INDICATOR_BUFFERIMAGE_SIZE              80

@implementation BetIndicator

+(float)GetIndicatorSize
{
    if([ApplicationConfigure iPADDevice])
        return REAL_INDICATOR_SIZE_IPAD;
    else
        return REAL_INDICATOR_SIZE_IPHONE;
}

+(float)GetBufferImageSize
{
    return INDICATOR_BUFFERIMAGE_SIZE;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        m_ImageNumber = NULL;
		CGFloat clrvals[] = {0.1, 0.1, 0.05, 1.0};
		m_ShadowClrSpace = CGColorSpaceCreateDeviceRGB();
		m_ShadowClrs = CGColorCreate(m_ShadowClrSpace, clrvals);
		m_ShadowSize = CGSizeMake(3, 3);
        m_nSeatID = -1;
        m_bShowBet = YES;
    }
    return self;    
}

-(void)dealloc
{
    if(m_ImageNumber != NULL)
        CGImageRelease(m_ImageNumber);
    
	CGColorSpaceRelease(m_ShadowClrSpace);
	CGColorRelease(m_ShadowClrs);
    
    
}

-(void)DrawBackground:(CGContextRef)context at:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, m_ShadowSize, 3, m_ShadowClrs);
    [RenderHelper DrawBetSignBackground:context at:rect]; 
    CGContextRestoreGState(context);
}

-(void)DrawNumber:(CGContextRef)context at:(CGRect)rect
{
    float fSize = rect.size.width*0.8;
    float fImageWidth = CGImageGetWidth(m_ImageNumber);
    float fImageHeight = CGImageGetHeight(m_ImageNumber);
    float fRatio = fImageWidth/fImageHeight;
    float w, h;
    if(1.0 < fRatio)
    {
        w = 0.8*fSize;
        h = w/fRatio;
    }
    else
    {
        h = 0.8*fSize;
        w = h*fRatio;
    }
    float sx = rect.origin.x + (rect.size.width-w)/2.0;
    float sy = rect.origin.y + (rect.size.height-h)/2.0;
    CGRect rt = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, rt, m_ImageNumber);
}

-(void)DrawQMark:(CGContextRef)context at:(CGRect)rect
{
    float fSize = rect.size.width*0.4;
    float sx = rect.origin.x + (rect.size.width-fSize)/2.0;
    float sy = rect.origin.y + (rect.size.height-fSize)/2.0;
    CGRect rt = CGRectMake(sx, sy, fSize, fSize);
    [RenderHelper DrawYellowQmark:context at:rt]; 
}

-(void)DrawIndicator:(CGContextRef)context at:(CGRect)rect
{
    [self DrawBackground:context at:rect];
    if(m_ImageNumber != NULL)
    {
        if(m_bShowBet == YES)
            [self DrawNumber:context at:rect];
        else
            [self DrawQMark:context at:rect];
    }
}

-(void)SetBet:(int)nBetMoney
{
    CGFloat clr[4] = {1.0, 1.0, 1.0, 1.0};
    NSString* str = [NSString stringWithFormat:@"%i", nBetMoney];
    char* snum = (char*)[str UTF8String];
    m_ImageNumber = CreateNumericImageWithColor(snum, clr);
}

-(void)ClearBet
{
    if(m_ImageNumber != NULL)
    {
        CGImageRelease(m_ImageNumber);
        m_ImageNumber = NULL;
    }
}


-(void)SetSeatID:(int)nID
{
    m_nSeatID = nID;
}

-(int)GetSeatID
{
    return m_nSeatID;
}

-(void)HideBet
{
    m_bShowBet = NO;
}

-(void)ShowBet
{
    m_bShowBet = YES;
}


@end
