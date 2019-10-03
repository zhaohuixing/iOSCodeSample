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
//#include "GameUtil.h"


@implementation PlayerBadget

-(id)initWithAchorPoint:(CGPoint)pt
{
    self = [super initWithAchorPoint:pt];
    if(self)
    {
        m_MinWidth *= [GUILayout GetPlayerBadgetRatioToAvatar];
        m_MinHeight *= [GUILayout GetPlayerBadgetRatioToAvatar];
        float archorSize = [GUILayout GetMsgBoardViewWidth]*[GUILayout GetTMSViewAchorRatio]*[GUILayout GetPlayerBadgetRatioToAvatar];
  
        CGRect rect = CGRectMake(m_MinWidth-archorSize, 0, m_MaxWidth, m_MaxHeight-m_MinHeight);
        [m_ScoreBoard setFrame:rect];
        [m_ScoreBoard SetAchorAtLeft:0.5];
        [m_MsgBoard setFrame:rect];
        [m_MsgBoard SetAchorAtLeft:0.5];
    }
    return self;
}

-(void)UpdateLargeViewLayout
{
    float sx = m_AchorPoint.x;//m_AchorPoint.x-m_MaxWidth;
    float sy = m_AchorPoint.y-m_MaxHeight*0.5;
    CGRect rect = CGRectMake(sx, sy, m_MaxWidth, m_MaxHeight);
    [self setFrame:rect];
    sx = 0;//(m_MaxWidth-m_MinWidth);
    sy = (m_MaxHeight-m_MinHeight)*0.5;;
    rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [m_Avatar setFrame:rect];
}

-(void)UpdateSmallViewLayout
{
    float sx = m_AchorPoint.x;//m_AchorPoint.x-m_MinWidth;
    float sy = m_AchorPoint.y-m_MinHeight*0.5;
    CGRect rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [self setFrame:rect];
    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [m_Avatar setFrame:rect];
}


@end
