//
//  CGameSectionBase.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameConstants.h"
#import "GambleLobby.h"
#import "GamePlayer.h"
#import "ActivePlayerAnimator.h"

@interface CGameSectionBase : NSObject<IGameSection>
{
@protected
    id<GameControllerDelegate>          m_GameController;
    GamePlayer*                         m_Players[4];
    ActivePlayerAnimator*               m_PlayingSpinner;
    
    int                                 m_nPlayerTurnIndex;

    
    CGPoint                             m_ptTouchStart;
    CGPoint                             m_ptTouchEnd;
    NSTimeInterval                      m_timeTouchStart;

}

-(id)init;
-(void)Draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)AssignController:(id<GameControllerDelegate>)controller;
-(void)OnTimerEvent;
-(void)UpdateGameLayout;
-(void)ForceClosePlayerMenus;


-(GamePlayer*)GetPlayer:(int)nSeatID;
-(GamePlayer*)GetMyself;
-(id)GetPlayerAtSeat:(int)nSeatID;

-(void)LocatePlayingSpinner;
-(int)GetCurrentActivePlayingSeat;
-(void)ShowPlayersPledgeInformation;

-(void)RestoreOffLineReadyState;

-(int)GetAcitvitedPlayersNumber;

-(void)ShutdownSection;

-(void)StartGameSection;

-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID;

@end
