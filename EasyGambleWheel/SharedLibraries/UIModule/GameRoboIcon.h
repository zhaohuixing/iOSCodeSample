//
//  GameRoboIcon.h
//  XXXXX
//
//  Created by Zhaohui Xing on 11-08-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameRoboIcon : UIView
{
@private
    CGImageRef      m_IconLose[3];
    CGImageRef      m_Icon;
    CGImageRef      m_IconWin[3];
    CGImageRef      m_IconPlay[3];
    CGImageRef      m_MasterIcon;
    CGImageRef      m_MasterIconLose[3];
    CGImageRef      m_MasterIconWin[3];
    CGImageRef      m_MasterIconPlay[3];
    CGImageRef      m_Micphone;
    CGImageRef      m_Pen;

    BOOL            m_bMaster;
    BOOL            m_bSpeaking;
    BOOL            m_bWritting;

    int             m_nState;
    int             m_nTimerCount;
}

-(void)SetMaster:(BOOL)bMaster;
-(void)SetSpeaking:(BOOL)bSpeaking;
-(void)SetWritting:(BOOL)bWritting;
-(void)OnTimeEvent;
-(BOOL)IsMaster;
-(BOOL)IsSpeaking;
-(BOOL)IsWritting;
-(void)SetStateIdle;
-(void)SetStatePlay;
-(void)SetStateWin;
-(void)SetStateLose;
-(void)SetState:(int)nState;
-(int)GetState;


@end
