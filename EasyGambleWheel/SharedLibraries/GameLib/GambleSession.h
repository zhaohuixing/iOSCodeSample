//
//  GambleSession.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "GameUtiltyObjects.h"

@class GambleLobby;

@interface GambleSession : NSObject
{
@private
    GambleLobby*         m_Parent;
    
    CLuckScope*          m_Luck2Scopes[2];
    CLuckScope*          m_Luck4Scopes[4];
    CLuckScope*          m_Luck6Scopes[6];
    CLuckScope*          m_Luck8Scopes[8];

    int                  m_nGamePlayType;
    int                  m_nGamePlayState;
    
    int                  m_nPosition;
    int                  m_nWinScopeIndex;

    //This is temperoray variable for test
    int                  m_nChips;
}

-(void)RegisterParent:(GambleLobby*)parent;

-(void)SetGameType:(int)nType;
-(int)GetGameType;
-(void)SetGameState:(int)nState;
-(int)GetGameState;
-(void)PointerStopAt:(int)nAngle;
-(int)GetPointerPosition;
-(int)GetWinScopeIndex;
-(void)Reset;


- (int)GetMyCurrentMoney;
- (void)AddMoneyToMyAccount:(int)nChips;
-(void)PlayCurrentGameStateSound;
@end
