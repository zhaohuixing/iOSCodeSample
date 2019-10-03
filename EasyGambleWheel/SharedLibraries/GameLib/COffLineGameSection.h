//
//  COffLineGameSection.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGameSectionBase.h"

@interface COffLineGameSection : CGameSectionBase
{
@private
    NSTimeInterval          m_OffLineReadyPlayTime;
    NSTimeInterval          m_OffLineResetToReadyDelay;
    BOOL                    m_bInOffLineReadyPlay;

    BOOL                    m_bOnHold;
}

-(id)init;

-(void)Release;
-(int)GetGameOnlineState;

-(void)OnTouchBegin:(CGPoint)pt;
-(void)OnTouchMove:(CGPoint)pt;
-(void)OnTouchEnd:(CGPoint)pt;
-(void)OnTouchCancel:(CGPoint)pt;

-(void)OnTimerEvent;

-(void)InitializeDefaultPlayersConfiguration;

-(int)GetMyCurrentMoney;
-(void)AddMoneyToMyAccount:(int)nChips;
-(int)GetPlayerCurrentMoney:(int)nSeat;
-(void)AddMoneyToPlayerAccount:(int)nChips inSeat:(int)nSeat;

-(void)UpdateForGameStateChange;
-(void)UpdateForGameTypeChange;

-(void)HandleNonSpinTouchEvent;

-(void)HoldMyTurnIfNeeded;

-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID;

-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney;

-(void)RestoreOffLineReadyState;

-(void)PauseGame;

-(void)CancelPendPlayerBet;

-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips;

-(void)RedeemAdViewClosed;

-(NSString*)GetPlayerName:(int)nSeatID;

-(BOOL)IsSystemOnHold;

-(void)SetSystemOnHold:(BOOL)bOnHold;

-(void)ShutdownSection;
-(void)StartGameSection;

-(int)GetActivatedPlayerCount;

@end
