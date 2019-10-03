//
//  GameRoboIcon.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameRoboIcon.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#include "drawhelper.h"

@implementation GameRoboIcon

- (void)InitWinIcons
{
    UIImage* roboImage = [UIImage imageNamed:@"roboicon.png"];
    m_IconWin[0] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robo2.png"];
    m_IconWin[1] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robo3.png"];
    m_IconWin[2] = CGImageRetain(roboImage.CGImage);
    
    roboImage = [UIImage imageNamed:@"roboiconhi.png"];
    m_MasterIconWin[0] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robohi2.png"];
    m_MasterIconWin[1] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robohi3.png"];
    m_MasterIconWin[2] = CGImageRetain(roboImage.CGImage);
}

- (void)InitPlayIcons
{
    UIImage* roboImage = [UIImage imageNamed:@"robo4.png"];
    m_IconPlay[0] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"roboicon.png"];
    m_IconPlay[1] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robo5.png"];
    m_IconPlay[2] = CGImageRetain(roboImage.CGImage);
    
    roboImage = [UIImage imageNamed:@"robohi4.png"];
    m_MasterIconPlay[0] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"roboiconhi.png"];
    m_MasterIconPlay[1] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robohi5.png"];
    m_MasterIconPlay[2] = CGImageRetain(roboImage.CGImage);
}

- (void)InitLoseIcons
{
    UIImage* roboImage = [UIImage imageNamed:@"robodead0.png"];
    m_IconLose[0] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robodead1.png"];
    m_IconLose[1] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robodead2.png"];
    m_IconLose[2] = CGImageRetain(roboImage.CGImage);
    
    roboImage = [UIImage imageNamed:@"robodeadhi0.png"];
    m_MasterIconLose[0] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robodeadhi1.png"];
    m_MasterIconLose[1] = CGImageRetain(roboImage.CGImage);
    roboImage = [UIImage imageNamed:@"robodeadhi2.png"];
    m_MasterIconLose[2] = CGImageRetain(roboImage.CGImage);
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIImage* roboImage = [UIImage imageNamed:@"roboicon.png"];
        m_Icon = CGImageRetain(roboImage.CGImage);
        UIImage* roboImageHi = [UIImage imageNamed:@"roboiconhi.png"];
        m_MasterIcon = CGImageRetain(roboImageHi.CGImage);
        UIImage* micImage = [UIImage imageNamed:@"micphoneicon.png"];
        m_Micphone = CGImageRetain(micImage.CGImage);

        UIImage* penImage = [UIImage imageNamed:@"penicon.png"];
        m_Pen = CGImageRetain(penImage.CGImage);
        
        [self InitWinIcons];
        [self InitPlayIcons];
        [self InitLoseIcons];
        
        
        m_nState = ROBO_STATE_IDLE;
        m_nTimerCount = 0;
        m_bSpeaking = NO;
        m_bWritting = NO;
        m_bMaster = NO;
    }
    return self;
}

- (void)dealloc
{
    CGImageRelease(m_Icon);
    CGImageRelease(m_MasterIcon);
    CGImageRelease(m_Micphone);
    CGImageRelease(m_Pen);
    for(int i = 0; i < 3; ++i)
    {
        CGImageRelease(m_IconLose[i]);
        CGImageRelease(m_IconWin[i]);
        CGImageRelease(m_IconPlay[i]);
        CGImageRelease(m_MasterIconLose[i]);
        CGImageRelease(m_MasterIconWin[i]);
        CGImageRelease(m_MasterIconPlay[i]);
    }
    
}

-(CGImageRef)GetCurrentImage
{
    int index = 0;
    if(0 <= m_nTimerCount && m_nTimerCount < 3)
        index = m_nTimerCount;
    else if(3 <= m_nTimerCount && m_nTimerCount < 6)
        index = 5 - m_nTimerCount;
    
    switch(m_nState)
    {
        case ROBO_STATE_PLAY:
        {    
            if(m_bMaster)
                return m_MasterIconPlay[index];
            else
                return m_IconPlay[index];
        }    
        case ROBO_STATE_WIN:
        {    
            if(m_bMaster)
                return m_MasterIconWin[index];
            else
                return m_IconWin[index];
        }    
        case ROBO_STATE_LOSE:
        {    
            if(m_bMaster)
                return m_MasterIconLose[index];
            else
                return m_IconLose[index];
        }    
        default: 
        {    
            if(m_bMaster)
                return m_MasterIcon;
            else
                return m_Icon;
        }    
    }
}

- (void)DrawRoboIcon:(CGContextRef)context withRect:(CGRect)rect
{
    CGImageRef image = [self GetCurrentImage];
    float imgw = CGImageGetWidth(image);
    float imgh = CGImageGetHeight(image);
    float imgratio = imgw/imgh;
    float w = rect.size.width;
    float h = rect.size.height/imgratio;
    CGRect imgRect = CGRectMake(0, 0, w, h);
    CGContextDrawImage(context, imgRect, image);
}

- (void)DrawMicIcon:(CGContextRef)context withRect:(CGRect)rect
{
    float w = rect.size.width*0.5;
    float h = rect.size.height*0.5;
    float sx = rect.size.width*0.25;
    float sy = rect.size.height*0.5;
    if(m_bWritting == YES)
        sx = 0.0;
    CGRect imgRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, imgRect, m_Micphone);
}

- (void)DrawPenIcon:(CGContextRef)context withRect:(CGRect)rect
{
    float w = rect.size.width*0.5;
    float h = rect.size.height*0.5;
    float sx = rect.size.width*0.25;
    float sy = rect.size.height*0.5;
    if(m_bSpeaking == YES)
        sx = rect.size.width*0.5;
    CGRect imgRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, imgRect, m_Pen);
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawRoboIcon:context withRect:rect];
    if(m_bSpeaking == YES)
        [self DrawMicIcon:context withRect:rect];
    if(m_bWritting == YES)
        [self DrawPenIcon:context withRect:rect];
        
}


-(void)SetSpeaking:(BOOL)bSpeaking
{
    m_bSpeaking = bSpeaking;
	[self setNeedsDisplay];
}

-(void)SetWritting:(BOOL)bWritting
{
    m_bWritting = bWritting;
	[self setNeedsDisplay];
}

-(void)SetMaster:(BOOL)bMaster
{
    m_bMaster = bMaster;
	[self setNeedsDisplay];
}

-(void)OnTimeEvent
{
    if(m_nState != ROBO_STATE_IDLE)
    {    
        m_nTimerCount = (m_nTimerCount+1)%6;
        [self setNeedsDisplay];
    }    
}

-(BOOL)IsMaster
{
    return m_bMaster;
}

-(BOOL)IsSpeaking
{
    return m_bSpeaking;
}

-(BOOL)IsWritting
{
    return m_bWritting;
}

-(void)SetStateIdle
{
    m_nState = ROBO_STATE_IDLE;
    [self setNeedsDisplay];
}

-(void)SetStatePlay
{
    m_nState = ROBO_STATE_PLAY;
    m_nTimerCount = 0;
    [self setNeedsDisplay];
}

-(void)SetStateWin
{
    m_nState = ROBO_STATE_WIN;
    m_nTimerCount = 0;
    [self setNeedsDisplay];
}

-(void)SetStateLose
{
    m_nState = ROBO_STATE_LOSE;
    m_nTimerCount = 0;
    [self setNeedsDisplay];
}

-(void)SetState:(int)nState
{
    m_nState = nState;
    m_nTimerCount = 0;
    [self setNeedsDisplay];
}

-(int)GetState
{
    return m_nState;
}

@end
