//
//  PlayerBadget.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PlayerBadget.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#import "StringFactory.h"
#include "drawhelper.h"
#import "CGameLayout.h"
//#include "GameUtil.h"


@implementation PlayerBadget

-(id)initWithAchorPoint:(CGPoint)pt
{
    self = [super initWithAchorPoint:pt];
    if(self)
    {
        m_MinWidth = [CGameLayout GetBulletinUnitSize];
        m_MinHeight = [CGameLayout GetBulletinUnitSize];
  
        CGRect rect = CGRectMake(0, m_MinHeight, m_MaxWidth, m_MaxHeight-m_MinHeight);
        [m_ScoreBoard setFrame:rect];
        [m_ScoreBoard SetAchorAtTop:0.5];
        [m_MsgBoard setFrame:rect];
        [m_MsgBoard SetAchorAtTop:0.5];
        m_NameTag.hidden = YES;
    }
    return self;
}


-(void)UpdateLargeViewLayout
{
    float sx = m_AchorPoint.x-m_MaxWidth*0.5;
    float sy = m_AchorPoint.y;
    CGRect rect = CGRectMake(sx, sy, m_MaxWidth, m_MaxHeight);
    [self setFrame:rect];
    sx = (m_MaxWidth-m_MinWidth)*0.5;
    sy = 0;//(m_MaxHeight-m_MinHeight)*0.5;
    rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [m_Avatar setFrame:rect];
}

-(void)UpdateSmallViewLayout
{
    float sx = m_AchorPoint.x-m_MinWidth*0.5;
    float sy = m_AchorPoint.y;
    CGRect rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [self setFrame:rect];
    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [m_Avatar setFrame:rect];
}


@end
