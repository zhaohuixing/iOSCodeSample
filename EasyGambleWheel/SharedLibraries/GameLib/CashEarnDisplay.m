//
//  CashEarnDisplay.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "CashEarnDisplay.h"
#include "drawhelper.h"
#import "GUILayout.h"
#import "RenderHelper.h"

@implementation CashEarnDisplay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_ImageNumber = NULL;
        m_nSeatID = 0;
        m_bEnable = YES;
    }
    return self;
}

-(BOOL)IsEnable
{
    return m_bEnable;
}

-(void)SetEnable:(BOOL)bEnable
{
    m_bEnable = bEnable;
    [self setNeedsDisplay];
}


-(void)dealloc
{
    if(m_ImageNumber)
        CGImageRelease(m_ImageNumber);
    
    
}

-(void)SetPlayerIndex:(int)nSeat
{
    m_nSeatID = nSeat;
}

-(void)SetCurrentMoney:(int)nChip
{
    if(m_ImageNumber)
    {    
        CGImageRelease(m_ImageNumber);
        m_ImageNumber = NULL;
    }    

    CGFloat clr[4] = {0.99, 0.85, 0.0, 1.0};
    NSString* str = [NSString stringWithFormat:@"%i", nChip];
    char* snum = (char*)[str UTF8String];
    m_ImageNumber = CreateNumericImageWithColor(snum, clr);
    [self setNeedsDisplay];
}

-(void)ClearCurrentMoney
{
    if(m_ImageNumber)
    {    
        CGImageRelease(m_ImageNumber);
        m_ImageNumber = NULL;
    }    
}

-(void)DrawNumber:(CGContextRef)context at:(CGRect)rect
{
    float fSize = rect.size.width*0.5;
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

- (void)DrawCashDisplay:(CGContextRef)context
{
    float h = [GUILayout GetCashEarnDislayIconHeight];
    float w = [GUILayout GetCashEarnDislayWidth];
    float sx = 0;
    float sy = 0;
    CGRect rect = CGRectMake(sx, sy, w, h);
    if(m_nSeatID == 0)
        [RenderHelper DrawCashEarnIconMe:context at:rect];
    else
        [RenderHelper DrawCashEarnIconOther:context at:rect];
    sy = h;
    rect = CGRectMake(sx, sy, w, w);
    [RenderHelper DrawCashOctagon:context at:rect]; 
    if(m_ImageNumber != NULL)
    {
        [self DrawNumber:context at:rect];
    }
}

-(void)DrawCashDisableDisplay:(CGContextRef)context
{
    float h = [GUILayout GetCashEarnDislayIconHeight];
    float w = [GUILayout GetCashEarnDislayWidth];
    float sx = 0;
    float sy = 0;
    CGRect rect = CGRectMake(sx, sy, w, h);
    if(m_nSeatID == 0)
    {    
        [RenderHelper DrawDisableCashEarnIconMe:context at:rect];
    }    
    else
    {    
        [RenderHelper DrawDisableCashEarnIconOther:context at:rect];
    }    
    sy = h;
    rect = CGRectMake(sx, sy, w, w);
    CGContextSetAlpha(context, 0.25);
    [RenderHelper DrawCashOctagon:context at:rect]; 
    if(m_ImageNumber != NULL)
    {
        CGContextSetAlpha(context, 1.0);
        [self DrawNumber:context at:rect];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if(m_bEnable)
        [self DrawCashDisplay:context];
    else
        [self DrawCashDisableDisplay:context];
    CGContextRestoreGState(context);
}

-(void)Open
{
    self.hidden = NO;
    [self setNeedsDisplay];
}

-(void)Close
{
    self.hidden = YES;
}

-(BOOL)IsOpen
{
    BOOL bRet = (self.hidden == NO);
    return bRet;
}

@end
