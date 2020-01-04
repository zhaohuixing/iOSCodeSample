//
//  Bulletin.m
//  MindFire
//
//  Created by Zhaohui Xing on 10-04-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "GameBaseView.h"
#import "DealController.h"
#import "Bulletin.h"
#import "CGameLayout.h"
#import "RenderHelper.h"
#include "GameUtility.h"


@implementation BulletinSign 

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
        m_Count = 0;
        m_bWinCount = NO;
        self.backgroundColor = [UIColor clearColor];
        m_bUsed2NonWinSign = NO;
        m_fRotateAngle = 0.0;
        
    }
    return self;
}    

- (void)SetCount:(int)n
{
    m_Count = n;
}

- (void)SetRotate:(float)fAngle
{
    m_fRotateAngle = fAngle;
}

- (void)SetType:(BOOL)bWinCount
{
    m_bWinCount = bWinCount;
}

- (void)OnTimerEvent
{
	[self setNeedsDisplay];
}

- (void)Reset
{
    m_Count = 0;
}


- (void)Use2NonWinSign
{
    m_bUsed2NonWinSign = YES;
}

- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if(!m_bWinCount && m_bUsed2NonWinSign)
        [RenderHelper DrawBulletinSign2:context withSign:m_Count inRect:rect withType:m_bWinCount];
    else 
    {   
        if(m_fRotateAngle == 0)
            [RenderHelper DrawBulletinSign:context withSign:m_Count inRect:rect withType:m_bWinCount];
        else 
            [RenderHelper DrawRotateBulletinSign:context withSign:m_Count inRect:rect withAngle:m_fRotateAngle];
    }    
    CGContextRestoreGState(context);
}

@end


@implementation Bulletin

- (id)initWithFrame2:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) 
	{
		// Initialization code
        m_Parent = nil;
		m_nWinDeals = 0;
        self.backgroundColor = [UIColor clearColor];
        
        CGRect rect = CGRectMake(0, 0, [CGameLayout GetBulletinUnitSize], [CGameLayout GetBulletinUnitSize]);
        m_DealSign = [[BulletinSign alloc] initWithFrame:rect];
        [m_DealSign SetType:NO];
        [m_DealSign Use2NonWinSign];
        [self addSubview:m_DealSign];
        [m_DealSign release];
        
        rect = CGRectMake([CGameLayout GetBulletinUnitSize], 0, [CGameLayout GetBulletinUnitSize], [CGameLayout GetBulletinUnitSize]);
        m_WinSign = [[BulletinSign alloc] initWithFrame:rect];
        [m_WinSign SetType:YES];
        [self addSubview:m_WinSign];
        [m_WinSign release];
    }
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) 
	{
		// Initialization code
        m_Parent = nil;
		m_nWinDeals = 0;
        self.backgroundColor = [UIColor clearColor];
	
        CGRect rect = CGRectMake(0, 0, [CGameLayout GetBulletinUnitSize], [CGameLayout GetBulletinUnitSize]);
        m_DealSign = [[BulletinSign alloc] initWithFrame:rect];
        [m_DealSign SetType:NO];
        [self addSubview:m_DealSign];
        [m_DealSign release];

        rect = CGRectMake([CGameLayout GetBulletinUnitSize], 0, [CGameLayout GetBulletinUnitSize], [CGameLayout GetBulletinUnitSize]);
        m_WinSign = [[BulletinSign alloc] initWithFrame:rect];
        [m_WinSign SetType:YES];
        [self addSubview:m_WinSign];
        [m_WinSign release];
    }
	return self;
}

- (void)OnTimerEvent
{
	[self setNeedsDisplay];
}

- (int)GetViewType
{
	return GAME_VIEW_BULLETIN;
}

- (void)UpdateGameViewLayout
{
	[self setNeedsDisplay];
}

- (void)Reset
{
	m_nWinDeals = 0;
	[self setNeedsDisplay];
}	
 
- (void)setNeedsDisplay
{
    if(m_Parent != nil)
    {    
        int nDeals = [m_Parent GetDealLeft]; 
        float fRatio = [m_Parent GetTimeSpentRatio];
        float fAngle = 0.0;
        if(0.0 < fRatio)
            fAngle = 360*fRatio;
        [m_DealSign SetCount:nDeals];
        [m_DealSign SetRotate:fAngle];
        [m_DealSign setNeedsDisplay];
    }    
    [m_WinSign SetCount:m_nWinDeals];
    [m_WinSign setNeedsDisplay]; 
    [super setNeedsDisplay];
}

- (void)AddWinScore
{
	++m_nWinDeals;
	[self setNeedsDisplay];
}	

- (void)dealloc 
{
    m_Parent = nil;
    [super dealloc];
}

- (void)SetParent:(DealController*)parent
{
    m_Parent = parent;
}

- (void)AddNonWinPoint:(int)nPoint
{
    [m_DealSign SetCount:nPoint];
    [m_DealSign setNeedsDisplay];
}

- (void)AddWinPoint:(int)nPoint
{
	m_nWinDeals = nPoint;
    [m_WinSign SetCount:m_nWinDeals];
    [m_WinSign setNeedsDisplay]; 
}

@end
