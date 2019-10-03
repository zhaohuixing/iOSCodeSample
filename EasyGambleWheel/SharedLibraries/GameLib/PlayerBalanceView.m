//
//  PlayerBalanceView.m
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-12-05.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "PlayerBalanceView.h"
#import "RenderHelper.h"
#import "GUILayout.h"
#include "drawhelper.h"

@implementation PlayerBalanceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_ImageNumber = NULL; 
    }
    return self;
}

-(void)dealloc
{
    if(m_ImageNumber != NULL)
        CGImageRelease(m_ImageNumber);
    
}

-(void)SetMyCurrentMoney:(int)nChips
{
    if(m_ImageNumber != NULL)
        CGImageRelease(m_ImageNumber);
    
    CGFloat clr[4] = {0.99, 0.85, 0.0, 1.0};
    NSString* str = [NSString stringWithFormat:@"%i", nChips];
    char* snum = (char*)[str UTF8String];
    m_ImageNumber = CreateNumericImageWithColor(snum, clr);
}

-(void)DrawNumber:(CGContextRef)context at:(CGRect)rect
{
    float fSize = rect.size.width*0.7;
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
    CGContextSaveGState(context);
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [RenderHelper DrawCashOctagon:context at:rect]; 
    if(m_ImageNumber != NULL)
    {
        [self DrawNumber:context at:rect];
    }
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawCashDisplay:context];
}


@end
