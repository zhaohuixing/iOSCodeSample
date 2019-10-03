//
//  GambleLobby.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-09-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "CGambleWheel.h"

@class CPinActionLevel;
@class GambleSession;
@class GamePlayer;
//??@class BetIndicator;
//??@class ChoiceDisplay;
//??@class GambleLobbySeat;
//??@class ActivePlayerAnimator;
//??@class WinnerAnimator;

@interface GambleLobby : NSObject<GameStateDelegate>
{
@private    
    GambleSession*          m_GameSession;
    CGambleWheel*           m_GambleWheel;
}

//- (void)UpdateGameLayout;
- (void)OnTimerEvent;
- (void)Draw:(CGContextRef)context inRect:(CGRect)rect;
- (void)SpinGambleWheel:(CPinActionLevel*)action;


//GameStateDelegate 
- (void)SetGameType:(int)nType theme:(int)themeType;
-(int)GetGameType;
-(void)SetGameState:(int)nState;
-(int)GetGameState;
-(void)PointerStopAt:(int)nAngle;
-(int)GetPointerPosition;
-(int)GetWinScopeIndex;

-(void)PauseGame;
-(void)ResumeGame;


@end
