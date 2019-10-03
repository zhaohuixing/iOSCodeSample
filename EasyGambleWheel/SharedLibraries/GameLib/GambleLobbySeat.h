//
//  GambleLobbySeat.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-17.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameConstants.h"
#import "PlayerBalanceView.h"

@class GambleLobby;

@interface GambleLobbySeat : UIView
{
@private    
    CGImageRef          m_OnlineAvatar;
 
	CGColorSpaceRef		m_ShadowClrSpace;
	CGColorRef			m_ShadowClrs;
	CGSize				m_ShadowSize;
    
    
    BOOL                m_Myself;

    int                 m_SeatID;

    id<GameControllerDelegate>  m_GameController;
    
    int                 m_nAnimationFrame;
    
    BOOL                m_bWinResult;
    
    NSTimeInterval      m_timerCount;
    
    BOOL                m_bEnable;
    
    BOOL                m_bActivePlayer;
    
    BOOL                m_bShowBalanceView;
    PlayerBalanceView*  m_BalanceView;
    NSTimeInterval      m_TimeStartShowBalance;
    BOOL                m_bInAnimation;

    BOOL                m_bOnlinePlayer;
}

-(void)InitializeSeat:(id<GameControllerDelegate>)pController withID:(int)nID withType:(BOOL)bMyself;
-(int)GetSeatNumber;
-(void)OnTimerEvent;
-(BOOL)UsingOnlineAvatarImage;
-(void)SetOnlineAvatarImage:(CGImageRef)image;
-(void)ReleaseOnlineAvatarImage;
-(void)SetGameResult:(BOOL)bWinResult;
-(BOOL)IsActive;
-(void)SetEnable:(BOOL)bEnable;
-(BOOL)GetEnable;
-(void)SetyActivePlayer:(BOOL)bActivePlayer;
-(void)ShowBalanceView;
-(void)CloseBalanceView;

-(void)SetPlayerOnlineStatus:(BOOL)bOnlinePlayer;
-(BOOL)IsOnlinePlayer;
-(void)SetSeatID:(int)nSeatID;
@end
