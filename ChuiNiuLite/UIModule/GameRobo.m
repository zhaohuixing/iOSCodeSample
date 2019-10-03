//
//  GameRobo.m
//  XXXXXX
//
//  Created by Zhaohui Xing on 11-07-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameRobo.h"
#import "GUILayout.h"
#import "GUIEventLoop.h"
#import "GUIBasicConstant.h"
#include "drawhelper.h"

@implementation GameRobo2

-(void)ClearScore
{
    m_nScore = 0;
}


-(id)initWithAchorPoint:(CGPoint)pt
{
    self = [super initWithFrame:CGRectMake(0, 0, 1, 1)];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        float archorSize = [GUILayout GetMsgBoardViewWidth]*[GUILayout GetTMSViewAchorRatio];
        
        m_MaxWidth = [GUILayout GetMsgBoardViewWidth] + [GUILayout GetAvatarWidth];
        m_MaxHeight = [GUILayout GetMsgBoardViewHeight];
        m_MinWidth = [GUILayout GetAvatarWidth];
        m_MinHeight = [GUILayout GetAvatarHeight];
        m_AchorPoint.x = pt.x;
        m_AchorPoint.y = pt.y;
       
        CGRect rect = CGRectMake(archorSize, 0, [GUILayout GetMsgBoardViewWidth], [GUILayout GetMsgBoardViewHeight]);
        m_MsgBoard = [[TextMsgDisplay alloc] initWithFrame:rect];
        [m_MsgBoard SetAchorAtRight:0.5];
		[self addSubview:m_MsgBoard];
		[m_MsgBoard release];
        m_MsgBoard.hidden = YES;
        
        rect = CGRectMake(0, 0, [GUILayout GetAvatarWidth], [GUILayout GetAvatarHeight]);
        m_Avatar = [[GameRoboIcon alloc] initWithFrame:rect];
		[self addSubview:m_Avatar];
		[m_Avatar release];
        
        
        rect = CGRectMake(archorSize, 0, [GUILayout GetMsgBoardViewWidth], [GUILayout GetMsgBoardViewHeight]);
        m_ScoreBoard = [[RoboListBoard alloc] initWithFrame:rect];
        [m_ScoreBoard SetAchorAtRight:0.5];
		[self addSubview:m_ScoreBoard];
		[m_ScoreBoard release];
        m_ScoreBoard.hidden = YES;
        [self ClearScore];
        
        m_PlayerID = @"";
        m_bAssigned = NO;
        m_nNameTipShowCount = 0;
        m_nAvatorTimerCount = 0;
        [self ClearScore];
        [self UpdateViewLayout];
    }
    return self;
}

-(void)SetAchor:(CGPoint)pt
{
    m_AchorPoint.x = pt.x;
    m_AchorPoint.y = pt.y;
    [self UpdateViewLayout];
}

-(void)UpdateLargeViewLayout
{
    float sx = m_AchorPoint.x-m_MaxWidth;
    float sy = m_AchorPoint.y-m_MaxHeight*0.5;
    CGRect rect = CGRectMake(sx, sy, m_MaxWidth, m_MaxHeight);
    [self setFrame:rect];
    sx = (m_MaxWidth-m_MinWidth);
    sy = (m_MaxHeight-m_MinHeight)*0.5;
    rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [m_Avatar setFrame:rect];
}

-(void)UpdateSmallViewLayout
{
    float sx = m_AchorPoint.x-m_MinWidth;
    float sy = m_AchorPoint.y-m_MinHeight*0.5;
    CGRect rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [self setFrame:rect];
    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [m_Avatar setFrame:rect];
}

-(void)UpdateViewLayout
{
    if(m_MsgBoard.hidden == NO || m_ScoreBoard.hidden == NO)
        [self UpdateLargeViewLayout];
    else
        [self UpdateSmallViewLayout];
}

-(void)OnMsgBoardChanged:(id)sender
{
    [self UpdateViewLayout];
}

-(void)OpenMessageBoard
{
    [self UpdateLargeViewLayout];
    m_MsgBoard.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnMsgBoardChanged:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_MsgBoard cache:YES];
    [UIView commitAnimations];
}

-(void)CloseMessageBoard
{
    m_MsgBoard.hidden = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnMsgBoardChanged:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_MsgBoard cache:YES];
    [UIView commitAnimations];
    
}


-(void)ShowMessageBoard:(BOOL)bShow
{
    if(m_MsgBoard.hidden == YES && bShow)
    {
        [self OpenMessageBoard];
    }
    else if(m_MsgBoard.hidden == NO && !bShow)
    {
        [self CloseMessageBoard];
    }
}

-(void)OnTimeEvent
{
    m_nAvatorTimerCount = (m_nAvatorTimerCount+1)%5;
    if(m_nAvatorTimerCount == 1)
        [m_Avatar OnTimeEvent];
    if(m_ScoreBoard.hidden == NO)
    {
        ++m_nNameTipShowCount;
        if(GAME_AVATAR_LABEL_TIMING*4 < m_nNameTipShowCount)
        {
            [self CloseScoreBoard];
        }
    }
}

-(void)OnMsgBoardClose
{
    [self UpdateViewLayout];
}

-(void)SetMessage:(NSString*)message
{
    if(m_ScoreBoard.hidden == NO)
    {
        [self CloseScoreBoard];
    }
    [m_MsgBoard SetTextMessage:message];
    [self ShowMessageBoard:YES];
}

-(void)SetSpeaking:(BOOL)bSpeaking
{
    [m_Avatar SetSpeaking:bSpeaking];
}

-(void)SetWritting:(BOOL)bWritting
{
    [m_Avatar SetWritting:bWritting];
}

-(void)SetMaster:(BOOL)bMaster
{
    [m_Avatar SetMaster:(BOOL)bMaster];
}

-(void)AssignID:(NSString*)playerID withName:(NSString*)playerName
{
    m_PlayerID = playerID;
    m_bAssigned = YES;
    [m_MsgBoard SetTextMessage:@""];
    [self ShowMessageBoard:NO];
    self.hidden = NO;
    [self ClearScore];
    [m_ScoreBoard SetTitle:playerName];
}

-(void)Resign
{
    m_PlayerID = @"";
    m_bAssigned = NO;
    [m_MsgBoard SetTextMessage:@""];
    [self ShowMessageBoard:NO];
    [m_Avatar SetMaster:NO];
    
    [m_Avatar SetSpeaking:NO];
    [m_Avatar SetWritting:NO];
    [m_Avatar SetStateIdle];
    
    self.hidden = YES;
}

-(NSString*)GetPlayerID
{
    return m_PlayerID; 
}

-(BOOL)IsActive
{
    return m_bAssigned;
}

-(BOOL)IsMaster
{
    return [m_Avatar IsMaster];
}

-(BOOL)IsSpeaking
{
    return [m_Avatar IsSpeaking];
}

-(BOOL)IsWritting
{
    return [m_Avatar IsWritting];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self IsActive] == NO)
        return;
    if(m_ScoreBoard.hidden == NO)
        return;
    
    [self OpenScoreBoard];
}	

-(void)UpdateScoreBoard
{
    [m_ScoreBoard EnableCell1:YES];
    [m_ScoreBoard EnableCell2:NO];
    [m_ScoreBoard EnableCell3:NO];
    [m_ScoreBoard EnableCell4:NO];
    [m_ScoreBoard SetCell1:[NSString stringWithFormat:@"%i", m_nScore] withText:@""];
}


-(void)OnScoreBoardOpen:(id)sender
{
    [self UpdateViewLayout];
}

-(void)OpenScoreBoard
{
    [self UpdateScoreBoard];
    if(m_MsgBoard.hidden == NO)
        [self ShowMessageBoard:NO];
    
    m_nNameTipShowCount = 0;
    [self UpdateLargeViewLayout];
    m_ScoreBoard.hidden = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnScoreBoardOpen:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_ScoreBoard cache:YES];
    [UIView commitAnimations];
}

-(void)OnScoreBoardClose:(id)sender
{
    [self UpdateViewLayout];
}

-(void)CloseScoreBoard
{
    m_nNameTipShowCount = 0;
    m_ScoreBoard.hidden = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(OnScoreBoardClose:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_ScoreBoard cache:YES];
    [UIView commitAnimations];
}

-(void)UpdateScore
{
    ++m_nScore;
}

-(void)SetScore:(int)nScore
{
    m_nScore = nScore;
}

-(int)GetScore
{
    return m_nScore;
}

-(void)SetStateIdle
{
    [m_Avatar SetStateIdle];
}

-(void)SetStatePlay
{
    [m_Avatar SetStatePlay];
}

-(void)SetStateWin
{
    [m_Avatar SetStateWin];
}

-(void)SetStateLose
{
    [m_Avatar SetStateLose];
}

-(void)SetState:(int)nState
{
    [m_Avatar SetState:nState];
}

-(int)GetState
{
    return [m_Avatar GetState];
}
@end
