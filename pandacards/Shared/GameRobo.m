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
#import "ApplicationConfigure.h"
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
        //float archorSize = [GUILayout GetMsgBoardViewWidth]*[GUILayout GetTMSViewAchorRatio];
        
        m_MaxWidth = [GUILayout GetMsgBoardViewWidth];
        m_MaxHeight = [GUILayout GetMsgBoardViewHeight] + [GUILayout GetAvatarHeight];
        m_MinWidth = [GUILayout GetAvatarWidth];
        m_MinHeight = [GUILayout GetAvatarHeight]*1.5;
        m_AchorPoint.x = pt.x;
        m_AchorPoint.y = pt.y;
       
        CGRect rect = CGRectMake(0, [GUILayout GetAvatarHeight]*0.5, [GUILayout GetAvatarWidth], [GUILayout GetAvatarHeight]);
        m_Avatar = [[GameRoboIcon alloc] initWithFrame:rect];
		[self addSubview:m_Avatar];
		[m_Avatar release];
        
        rect = CGRectMake(0, 0, [GUILayout GetAvatarWidth], [GUILayout GetAvatarHeight]*0.5);
        m_NameTag = [[UILabel alloc] initWithFrame:rect];
        m_NameTag.backgroundColor = [UIColor clearColor];
        [m_NameTag setTextColor:[UIColor yellowColor]];
        float fontSize = 14;
        if([ApplicationConfigure iPADDevice])
            fontSize = 24;
            
        m_NameTag.font = [UIFont fontWithName:@"Times New Roman" size:fontSize];
        [m_NameTag setTextAlignment:UITextAlignmentCenter];
        m_NameTag.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        m_NameTag.adjustsFontSizeToFitWidth = YES;
        [m_NameTag setText:@""];
		[self addSubview:m_NameTag];
		[m_NameTag release];
        m_NameTag.hidden = NO;
        
        
        rect = CGRectMake(0, 0, [GUILayout GetMsgBoardViewWidth], [GUILayout GetMsgBoardViewHeight]);
        m_MsgBoard = [[TextMsgDisplay alloc] initWithFrame:rect];
        [m_MsgBoard SetAchorAtBottom:0.5];
		[self addSubview:m_MsgBoard];
		[m_MsgBoard release];
        m_MsgBoard.hidden = YES;
        
        rect = CGRectMake(0, 0, [GUILayout GetMsgBoardViewWidth], [GUILayout GetMsgBoardViewHeight]);
        m_ScoreBoard = [[RoboListBoard alloc] initWithFrame:rect];
        [m_ScoreBoard SetAchorAtBottom:0.5];
		[self addSubview:m_ScoreBoard];
		[m_ScoreBoard release];
        m_ScoreBoard.hidden = YES;
        [self ClearScore];
        
        m_nScore = 0;
        m_PlayerID = nil;
        m_bAssigned = NO;
        m_nNameTipShowCount = 0;
        m_nAvatorTimerCount = 0;
        m_PlayerName = nil;
        m_CachedGKMatchPlayer = nil;
        [self ClearScore];
        [self UpdateViewLayout];
    }
    return self;
}

-(void)dealloc
{
    if(m_CachedGKMatchPlayer != nil)
    {
        [m_CachedGKMatchPlayer release];
        m_CachedGKMatchPlayer = nil;
    }
    if(m_PlayerID)
    {
        [m_PlayerID release];
    }
    if(m_PlayerName)
    {
        [m_PlayerName release];
    }
    [super dealloc];
}

-(void)SetAchor:(CGPoint)pt
{
    m_AchorPoint.x = pt.x;
    m_AchorPoint.y = pt.y;
    [self UpdateViewLayout];
}

-(void)UpdateLargeViewLayout
{
    float sx = m_AchorPoint.x-m_MaxWidth*0.5;
    float sy = m_AchorPoint.y-m_MaxHeight;
    CGRect rect = CGRectMake(sx, sy, m_MaxWidth, m_MaxHeight);
    [self setFrame:rect];
    sx = (m_MaxWidth-m_MinWidth)*0.5;
    sy = m_MaxHeight-m_MinHeight;
    rect = CGRectMake(sx, sy, m_MinWidth, [GUILayout GetAvatarHeight]*0.5);
    [m_NameTag setFrame:rect];
    sy = m_MaxHeight-[GUILayout GetAvatarHeight];
    rect = CGRectMake(sx, sy, m_MinWidth, [GUILayout GetAvatarHeight]);
    [m_Avatar setFrame:rect];
}

-(void)UpdateSmallViewLayout
{
    float sx = m_AchorPoint.x-m_MinWidth*0.5;
    float sy = m_AchorPoint.y-m_MinHeight;
    CGRect rect = CGRectMake(sx, sy, m_MinWidth, m_MinHeight);
    [self setFrame:rect];
    sx = 0;
    sy = [GUILayout GetAvatarHeight]*0.5;
    rect = CGRectMake(sx, sy, m_MinWidth, [GUILayout GetAvatarHeight]);
    [m_Avatar setFrame:rect];
    sx = 0;
    sy = 0;
    rect = CGRectMake(sx, sy, m_MinWidth, [GUILayout GetAvatarHeight]*0.5);
    [m_NameTag setFrame:rect];
    
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
        if(GAME_AVATAR_LABEL_TIMING*6 < m_nNameTipShowCount)
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
    m_PlayerID = [playerID copy];
    m_bAssigned = YES;
    [m_MsgBoard SetTextMessage:@""];
    [self ShowMessageBoard:NO];
    self.hidden = NO;
    [self ClearScore];
    m_PlayerName = [playerName copy]; //playerName; 
    NSString* sTitle = [NSString stringWithFormat:@"%@:%i", m_PlayerName, m_nScore];
    [m_ScoreBoard SetTitle:sTitle];
    [m_NameTag setText:m_PlayerName];
}

-(void)Resign
{
    if(m_PlayerID)
    {
        [m_PlayerID release];
    }
    m_PlayerID = nil;
    m_bAssigned = NO;
    [self ClearScore];
    if(m_PlayerName)
    {
        [m_PlayerName release];
    }
    [m_NameTag setText:@""];
    m_PlayerName = nil;
    [m_MsgBoard SetTextMessage:@""];
    [m_ScoreBoard ResetImages];
    [m_ScoreBoard SetTitle:@""];
    [self ShowMessageBoard:NO];
    [m_Avatar SetMaster:NO];
    
    [m_Avatar SetSpeaking:NO];
    [m_Avatar SetWritting:NO];
    [m_Avatar SetStateIdle];
    [m_Avatar ReleaseOnlineAvatarImage];
    if(m_CachedGKMatchPlayer != nil)
    {
        [m_CachedGKMatchPlayer release];
        m_CachedGKMatchPlayer = nil;
    }
    
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

-(void)OnScoreBoardOpen:(id)sender
{
    [self UpdateViewLayout];
    [m_ScoreBoard setNeedsDisplay];
}

-(void)OpenScoreBoard
{
    if(m_MsgBoard.hidden == NO)
        [self ShowMessageBoard:NO];
    
    m_nNameTipShowCount = 0;
    [self UpdateLargeViewLayout];
    if(m_ScoreBoard.hidden == NO)
        return;
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
    m_nScore = m_nScore+1;
    NSString* sTitle = @"Ghost:0";
    if(m_PlayerName)
    {    
        sTitle = [NSString stringWithFormat:@"%@:%i", m_PlayerName, m_nScore];
    }
    else 
    {
        sTitle = [NSString stringWithFormat:@"Ghost:%i", m_nScore];
    }
    [m_ScoreBoard SetTitle:sTitle];
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

-(void)SetImage1:(CGImageRef)image
{
    [m_ScoreBoard SetImage1:image];
}

-(void)SetImage2:(CGImageRef)image
{
    [m_ScoreBoard SetImage2:image];
}

-(void)SetImage3:(CGImageRef)image
{
    [m_ScoreBoard SetImage3:image];
}

-(void)ResetScoreBoardImages
{
    [m_ScoreBoard ResetImages];
}

-(void)LoadAppleGameCenterPlayerImage:(GKPlayer*)gkPlayer
{
    if(m_CachedGKMatchPlayer != nil)
    {    
        [m_CachedGKMatchPlayer release];
        m_CachedGKMatchPlayer = nil;   
    }    
    m_CachedGKMatchPlayer = [gkPlayer retain];
    if(m_CachedGKMatchPlayer != nil)
    {
        GKPhotoSize imgSize = GKPhotoSizeSmall;
        if(1.0 < [ApplicationConfigure GetCurrentDisplayScale])
            imgSize = GKPhotoSizeNormal;
        [m_CachedGKMatchPlayer loadPhotoForSize:imgSize withCompletionHandler:^(UIImage *photo, NSError *error) 
         {
             if(error)
             {
                 NSLog(@"GamePlayer LoadAppleGameCenterPlayerImage is failed for %@", [error localizedDescription]);
                 return;
             }
             if(photo && photo.CGImage && m_Avatar && (0 < photo.size.width && 0 < photo.size.height))
             {
                 [m_Avatar SetOnlineAvatarImage:CloneImage(photo.CGImage, true)];
                 [m_Avatar setNeedsDisplay];
             }
         }];
    }
}

@end
