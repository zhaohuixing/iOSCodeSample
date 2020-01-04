//
//  GameRobo.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-08-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameRoboIcon.h"
#import "TextMsgDisplay.h"
#import "RoboListBoard.h"

@interface GameRobo2 : UIView<TextMsgBoardDelegate>
{
@protected
    GameRoboIcon*               m_Avatar;
    TextMsgDisplay*             m_MsgBoard;
    RoboListBoard*              m_ScoreBoard;
    UILabel*                    m_NameTag;
    
    int                         m_nScore;
    
    float                       m_MaxWidth;
    float                       m_MaxHeight;
    float                       m_MinWidth;
    float                       m_MinHeight;
    CGPoint                     m_AchorPoint;
    NSString*                   m_PlayerID;
    BOOL                        m_bAssigned;
    int                         m_nNameTipShowCount;
    int                         m_nAvatorTimerCount;
    NSString*                   m_PlayerName;

@private
    GKPlayer*               m_CachedGKMatchPlayer;
}

-(id)initWithAchorPoint:(CGPoint)pt;
-(void)OnTimeEvent;
-(void)SetAchor:(CGPoint)pt;
-(void)UpdateViewLayout;
-(void)ShowMessageBoard:(BOOL)bShow;
-(void)SetMessage:(NSString*)message;
-(void)SetSpeaking:(BOOL)bSpeaking;
-(void)SetWritting:(BOOL)bWritting;
-(void)SetMaster:(BOOL)bMaster;
-(void)AssignID:(NSString*)playerID withName:(NSString*)playerName;
-(void)Resign;
-(NSString*)GetPlayerID;
-(BOOL)IsActive;
-(BOOL)IsMaster;
-(BOOL)IsSpeaking;
-(BOOL)IsWritting;
-(void)UpdateLargeViewLayout;
-(void)UpdateSmallViewLayout;
-(void)OpenScoreBoard;
-(void)CloseScoreBoard;
-(void)UpdateScore;
-(void)SetScore:(int)nScore;

-(void)SetImage1:(CGImageRef)image;
-(void)SetImage2:(CGImageRef)image;
-(void)SetImage3:(CGImageRef)image;
-(void)ResetScoreBoardImages;

-(int)GetScore;
-(void)SetStateIdle;
-(void)SetStatePlay;
-(void)SetStateWin;
-(void)SetStateLose;
-(void)SetState:(int)nState;
-(int)GetState;

-(void)LoadAppleGameCenterPlayerImage:(GKPlayer*)gkPlayer;

@end
