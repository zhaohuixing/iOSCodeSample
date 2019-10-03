//
//  COnLineGameSection.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <GameKit/GameKit.h>
#import "CGameSectionBase.h"


@interface COnLineGameSection : CGameSectionBase <GKMatchDelegate, GKSessionDelegate>
{
@private
    GKMatch*                m_AppleGameCenter;
    GKSession*              m_GKBTGameSession;
    NSString*               m_MyGKBTID;
    NSString*               m_MyGKBTName;
    NSString*               m_GKBTPeerID;
    
    BOOL                    m_bHost;
    
    BOOL                    m_bGKCenterMasterCheck;
    NSTimeInterval          m_TimeStartGKCenterMasterCheck;
    
    //AWS delay
    BOOL                    m_bAWSGameMasterSettingReceived;
    BOOL                    m_bAWSGamePeerBalanceReceived;
}

//////////////////////////////////////////////////
//Asynchronized call functions
//////////////////////////////////////////////////
- (void)callSingleParamenterFunctionOnMainThread: (SEL) selector withParam:(id)param;
- (void)callDualParamentersFunctionOnMainThread: (SEL) selector withParam1:(id)param1 withParam2:(id)param2;
//////////////////////////////////////////////////
//
//////////////////////////////////////////////////



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

-(void)PauseGame;

-(void)CancelPendPlayerBet;

-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips;

- (void)RedeemAdViewClosed;

-(NSString*)GetPlayerName:(int)nSeatID;

-(BOOL)IsSystemOnHold;

-(void)SetSystemOnHold:(BOOL)bOnHold;

-(void)ShutdownSection;

-(void)parserMessageInformation:(NSDictionary*)msgData fromPlayer:(NSString*)playerID;

-(void)SetOnlineGameHost:(BOOL)bHost;

-(BOOL)IsOnlineGameHost;

-(void)MakeOnlinePlayTurn;

-(void)SetOnLinePlayTurn;

-(int)GetEnabledOnlinePlayesCount;

-(int)GetPlayerSeatID:(NSString*)szPlayerID;
-(int)GetMySeatID;
-(GamePlayer*)GetPlayerByPlayerID:(NSString*)szPlayerID;

-(BOOL)IsMyTurn;

-(void)StartGameSection;

-(BOOL)IsOnlineGameStateReadyToPlay;

-(BOOL)HasGKCenterMaster;

-(void)StartGKCenterMasterCheck;

-(void)StopGKCenterMasterCheck;

-(void)NomiateGKCenterMasterInPeerToPeer;

-(void)DelayPostMyInfo;

-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID;

-(int)GetActivatedPlayerCount;

-(void)AWSNonMasterPlayerSendMasterSettingRequest;

-(void)AWSPlayerSendPeerBalanceRequest;

-(GKPlayer*)GetOnlinePlayer:(NSString*)playerID;

@end
