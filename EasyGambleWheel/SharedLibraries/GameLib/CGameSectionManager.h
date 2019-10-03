//
//  CGameSectionManager.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameConstants.h"
#import "GameCenterConstant.h"
#import "GambleLobby.h"
#import "AppleGameCenterEngine.h"
#import "GamePlayer.h"

@interface CGameSectionManager : NSObject<GameControllerDelegate, GameCenterOnlinePlayDelegate>
{
@public    
    id<IGameSection>        m_ActiveGameSection;
   
    id<IGameSection>        m_OfflineGameSection;
    id<IGameSection>        m_OnlineGameSection;
    
    
    GambleLobby*            m_GameLobby;
    
@private
    AppleGameCenterEngine*  m_AppleGameCenterAgent;
}

-(GamePlayer*)GetMyself;

-(void)Terminate;
-(void)RegisterGKInvitationListener;

//GameControllerDelegate methods
- (void)SetGameType:(int)nType theme:(int)themeType;
-(void)SetGameState:(int)nState;
-(int)GetGameType;
-(int)GetGameState;
-(int)GetGameOnlineState;
-(BOOL)IsOnline;
-(void)RegisterSubUIObject:(id)subUI;
-(void)OpenRedeemViewForPlayer:(int)nSeatID;
-(void)MakePlayerTransaction:(int)nSeatID;
-(BOOL)IsSystemOnHold;
-(void)SpinGambleWheel:(CPinActionLevel*)action;
-(int)GetWinScopeIndex;
-(void)HandleNonSpinTouchEvent;
-(void)SetSystemOnHold:(BOOL)bOnHold;
-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney;
-(void)ShutdownGameSection;
-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID;
-(void)GotoOfflineGame;

-(int)GetActivatedPlayerCount;

-(void)shutdownCurrentGame;

//Member functions
-(void)Draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)OnTimerEvent;
-(void)UpdateGameLayout;

-(void)InitializeDefaultPlayersConfiguration;

-(int)GetMyCurrentMoney;
-(void)AddMoneyToMyAccount:(int)nChips;
-(int)GetPlayerCurrentMoney:(int)nSeat;
-(void)AddMoneyToPlayerAccount:(int)nChips inSeat:(int)nSeat;
-(void)RedeemAdViewClosed;

-(void)DelayRegisterGameController;

-(NSString*)GetPlayerName:(int)nSeatID;
-(void)CancelPendPlayerBet;
-(void)ResetGameStateAndType;
-(BOOL)CanPlayerPlayGame:(int)nType inSeat:(int)nSeatID;
-(void)PlayerTranfereChipsFrom:(int)nSeat To:(int)nReceiverID withChips:(int)nChips;
-(void)StartNewGame;
-(void)PauseGame;
-(void)ResumeGame;
-(void)HoldMyTurnIfNeeded;
-(void)UpdateForGameStateChange;
-(void)UpdateForGameTypeChange;

-(void)OnTouchBegin:(CGPoint)pt;
-(void)OnTouchMove:(CGPoint)pt;
-(void)OnTouchEnd:(CGPoint)pt;
-(void)OnTouchCancel:(CGPoint)pt;

-(id)GetPlayerAtSeat:(int)nSeatID;

//Class methods
+(id<IGameSection>)CreateOffLineSectionInstance;
+(id<IGameSection>)CreateOnLineSectionInstance:(BOOL)bHost;
+(id<GameUIDelegate>)GetGlobalGameUIDelegate;

-(void)SetGKBTPeerID:(NSString*)peerID;
-(void)SetGKBTMyID:(NSString*)myID;
-(void)AdviseGKBTSession:(GKSession*)session;
-(void)StartGKBTSessionGamePreset;        

-(NSString*)GetInvitationSenderInitialDataString;
-(NSString*)GetInvitationRecieverInitialDataString;

@end
