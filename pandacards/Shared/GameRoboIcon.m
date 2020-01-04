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
#import "RenderHelper.h"
#import "ApplicationConfigure.h"

@implementation GameRoboIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        
        m_nState = ROBO_STATE_IDLE;
        m_nTimerCount = 0;
        m_bSpeaking = NO;
        m_bWritting = NO;
        m_bMaster = NO;
        m_OnlineAvatar = NULL;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{

    if(m_OnlineAvatar != NULL)
    {
        CGImageRelease(m_OnlineAvatar);
    }
    [super dealloc];
}

- (void)DrawAvatarPlay:(CGContextRef)context withRect:(CGRect)rect
{
    int index = 0;
    if(0 <= m_nTimerCount && m_nTimerCount < 3)
        index = m_nTimerCount;
    else if(3 <= m_nTimerCount && m_nTimerCount < 6)
        index = 5 - m_nTimerCount;
    
    if(m_bMaster)
        [RenderHelper DrawAvatarPlay:context withRect:rect withIndex:index withFlag:YES];
    else
        [RenderHelper DrawAvatarPlay:context withRect:rect withIndex:index withFlag:NO];
}

- (void)DrawAvatarIdle:(CGContextRef)context withRect:(CGRect)rect
{
    int index = 0;
    if(0 <= m_nTimerCount && m_nTimerCount < 3)
        index = m_nTimerCount;
    else if(3 <= m_nTimerCount && m_nTimerCount < 6)
        index = 5 - m_nTimerCount;
    
    if(m_bMaster)
        [RenderHelper DrawAvatarIdle:context withRect:rect withIndex:index withFlag:YES];
    else
        [RenderHelper DrawAvatarIdle:context withRect:rect withIndex:index withFlag:NO];
}

- (void)DrawAvatarResult:(CGContextRef)context withRect:(CGRect)rect
{
    int index = 0;
    if(0 <= m_nTimerCount && m_nTimerCount < 3)
        index = m_nTimerCount;
    else if(3 <= m_nTimerCount && m_nTimerCount < 6)
        index = 5 - m_nTimerCount;
    
    switch(m_nState)
    {
        case ROBO_STATE_WIN:
            if(m_bMaster)
                [RenderHelper DrawAvatarResult:context withRect:rect withIndex:index withResult:YES withFlag:YES];
            else
                [RenderHelper DrawAvatarResult:context withRect:rect withIndex:index withResult:YES withFlag:NO];
            break;    
        case ROBO_STATE_LOSE:
            if(m_bMaster)
                [RenderHelper DrawAvatarResult:context withRect:rect withIndex:index withResult:NO withFlag:YES];
            else
                [RenderHelper DrawAvatarResult:context withRect:rect withIndex:index withResult:NO withFlag:NO];
            break;    
    }
}

- (void)DrawDefaultRoboIcon:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextRef layerDC;
    CGLayerRef   layerObj;
    
    float fSize = [GUILayout GetAvatarImageSize];
    CGSize size =  CGSizeMake(fSize, fSize);
    layerObj = CGLayerCreateWithContext(context, size, NULL);
    layerDC = CGLayerGetContext(layerObj);
    CGRect rt = CGRectMake(0, 0, fSize, fSize);
    float shadowOffset = 3;
    if([ApplicationConfigure iPADDevice])
        shadowOffset *= 2;
    
    switch(m_nState)
    {
        case ROBO_STATE_PLAY:
            [self DrawAvatarPlay:layerDC withRect:rt];
            break;    
        case ROBO_STATE_WIN:
            [self DrawAvatarResult:layerDC withRect:rt];
            break;    
        case ROBO_STATE_LOSE:
            [self DrawAvatarResult:layerDC withRect:rt];
            break;    
        default: 
            [self DrawAvatarIdle:layerDC withRect:rt];
            break;    
    }

    CGContextDrawLayerInRect(context, rect, layerObj);    
    CGLayerRelease(layerObj);
}

-(void)DrawOnlineAvatarHat:(CGContextRef)context withRect:(CGRect)rect
{
    static float fSteps[3] = {0.0, 0.5, 1.0};
    
    float w = rect.size.width*0.2;
    float h = w*2.0/3.0;
    int index = 0;
    if(0 <= m_nTimerCount && m_nTimerCount < 3)
        index = m_nTimerCount;
    else if(3 <= m_nTimerCount && m_nTimerCount < 6)
        index = 5 - m_nTimerCount;
    
    float dY = h*0.3;
    float sx = rect.origin.x + (rect.size.width-w)/2.0;
    float sy = rect.origin.y + dY*fSteps[index];
    CGRect drawRect = CGRectMake(sx, sy , w, h);
    [RenderHelper DrawOnlinePlayeHat:context withRect:drawRect];
}

- (void)DrawOnlineAvatarIdle:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnlineAvatar);
    if(m_bMaster)
        [self DrawOnlineAvatarHat:context withRect:rect];
}

- (void)DrawOnlineAvatarPlay:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextDrawImage(context, rect, m_OnlineAvatar);
    int index = 0;
    if(0 <= m_nTimerCount && m_nTimerCount < 3)
        index = m_nTimerCount;
    else if(3 <= m_nTimerCount && m_nTimerCount < 6)
        index = 5 - m_nTimerCount;

    [RenderHelper DrawOnlinePlayerGesture:context withRect:rect withIndex:index];
    
    if(m_bMaster)
        [self DrawOnlineAvatarHat:context withRect:rect];
}

- (void)DrawOnlineAvatarResult:(CGContextRef)context withRect:(CGRect)rect
{
    [self DrawAvatarResult:context withRect:rect];
}

- (void)DrawOnlineAvatar:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextRef layerDC;
    CGLayerRef   layerObj;
    
    float fSize = [GUILayout GetAvatarImageSize];
    CGSize size =  CGSizeMake(fSize, fSize);
    layerObj = CGLayerCreateWithContext(context, size, NULL);
    layerDC = CGLayerGetContext(layerObj);
    CGRect rt = CGRectMake(0, 0, fSize, fSize);
    float shadowOffset = 3;
    if([ApplicationConfigure iPADDevice])
        shadowOffset *= 2;
    
    switch(m_nState)
    {
        case ROBO_STATE_PLAY:
            [self DrawOnlineAvatarPlay:layerDC withRect:rt];
            break;    
        case ROBO_STATE_WIN:
            [self DrawAvatarResult:layerDC withRect:rt];
            break;    
        case ROBO_STATE_LOSE:
            [self DrawAvatarResult:layerDC withRect:rt];
            break;    
        default: 
            [self DrawOnlineAvatarIdle:layerDC withRect:rt];
            break;    
    }
    
    CGContextDrawLayerInRect(context, rect, layerObj);    
    CGLayerRelease(layerObj);
}


- (void)DrawRoboIcon:(CGContextRef)context withRect:(CGRect)rect
{
    if(m_OnlineAvatar)
    {
        [self DrawOnlineAvatar:context withRect:rect];
    }
    else 
    {
        [self DrawDefaultRoboIcon:context withRect:rect];
    }
}

- (void)DrawMicIcon:(CGContextRef)context withRect:(CGRect)rect
{
/*    float w = rect.size.width*0.5;
    float h = rect.size.height*0.5;
    float sx = rect.size.width*0.25;
    float sy = rect.size.height*0.5;
    if(m_bWritting == YES)
        sx = 0.0;
    CGRect imgRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, imgRect, m_Micphone);*/
}

- (void)DrawPenIcon:(CGContextRef)context withRect:(CGRect)rect
{
/*    float w = rect.size.width*0.5;
    float h = rect.size.height*0.5;
    float sx = rect.size.width*0.25;
    float sy = rect.size.height*0.5;
    if(m_bSpeaking == YES)
        sx = rect.size.width*0.5;
    CGRect imgRect = CGRectMake(sx, sy, w, h);
    CGContextDrawImage(context, imgRect, m_Pen);*/
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawRoboIcon:context withRect:rect];
/*    if(m_bSpeaking == YES)
        [self DrawMicIcon:context withRect:rect];
    if(m_bWritting == YES)
        [self DrawPenIcon:context withRect:rect];
*/        
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
    if(self.hidden == NO)
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

-(BOOL)UsingOnlineAvatarImage
{
    BOOL bRet = (m_OnlineAvatar != NULL);
    return bRet;
}

-(void)SetOnlineAvatarImage:(CGImageRef)image
{
    if(m_OnlineAvatar)
    {
        CGImageRelease(m_OnlineAvatar);
        m_OnlineAvatar = NULL;
    }
    m_OnlineAvatar = image;
    [self setNeedsDisplay];
}

-(void)ReleaseOnlineAvatarImage
{
    if(m_OnlineAvatar)
    {
        CGImageRelease(m_OnlineAvatar);
        m_OnlineAvatar = NULL;
    }
}


@end
