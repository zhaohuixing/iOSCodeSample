//
//  GameConstants.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 11-11-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef SIMPLEGAMBLEWHEEL_GAMECONSTANTS_H
#define SIMPLEGAMBLEWHEEL_GAMECONSTANTS_H

@import GameKit;

#import "GameUtiltyObjects.h"


//Player online playing state
#define GAME_PLAYER_STATE_NORMAL            0
#define GAME_PLAYER_STATE_SUSPEND           1

#define GAME_ONLINE_STATE_OFFLINE           0
#define GAME_ONLINE_STATE_ONLINE            1


#define GAME_TYPE_8LUCK            0
#define GAME_TYPE_6LUCK            1
#define GAME_TYPE_4LUCK            2
#define GAME_TYPE_2LUCK            3

#define GAME_THEME_KULO             0
#define GAME_THEME_ANIMAL1          1
#define GAME_THEME_ANIMAL2          2
#define GAME_THEME_ANIMAL          3
#define GAME_THEME_FOOD            4
#define GAME_THEME_FLOWER          5
#define GAME_THEME_EASTEREGG       6
#define GAME_THEME_NUMBER          7


#define GAME_ONLINE_PLAYER_STATE_UNKNOWN           -1
#define GAME_ONLINE_PLAYER_STATE_READY             0
#define GAME_ONLINE_PLAYER_STATE_RUN               1
#define GAME_ONLINE_PLAYER_STATE_RESULT            2
#define GAME_ONLINE_PLAYER_STATE_RESET             3


#define GAME_STATE_READY           0
#define GAME_STATE_RUN             1
#define GAME_STATE_RESULT          2
#define GAME_STATE_RESET           3   //For in mult-player mode, all player reset state from result to ready

#define GAME_POINTER_SPIN_FAST              0
#define GAME_POINTER_SPIN_MEDIUM            1
#define GAME_POINTER_SPIN_SLOW              2
#define GAME_POINTER_SPIN_VIBRATION         3

#define GAME_POINTER_RUN_ANGLE_STEP                     2
#define GAME_POINTER_VIBRATION_ANGLE_UNIT               6
#define GAME_POINTER_MEDIUM_ANGLE_UNIT                  75
#define GAME_POINTER_FAST_ANGLE_UNIT					90 //130.0f
#define GAME_POINTER_FAST_ANGLE_MAXCOUNT				329


#define GAME_BET_THRESHOLD_8LUCK                        1
#define GAME_BET_THRESHOLD_6LUCK                        1 //10
#define GAME_BET_THRESHOLD_4LUCK                        1 //20
#define GAME_BET_THRESHOLD_2LUCK                        1 //40

#define GAME_PLAYTURN_TYPE_SEQUENCE                     0
#define GAME_PLAYTURN_TYPE_MAXBET                       1


#define PURCHASED_CHIPS_1       1000
#define PURCHASED_CHIPS_2       2100
#define PURCHASED_CHIPS_3       3200
#define PURCHASED_CHIPS_4       4400
#define PURCHASED_CHIPS_5       5800
#define PURCHASED_CHIPS_6       7600
#define PURCHASED_CHIPS_7       9200
#define PURCHASED_CHIPS_8       10400
#define PURCHASED_CHIPS_9       11800
#define PURCHASED_CHIPS_10      13600


#define GAME_DEFAULT_CHIPSINPACKET                      PURCHASED_CHIPS_1


#define PRODUCT_ID_1000CHIPS     @"com.xgadget.SimpleGambleWheel.1000Chips"
#define PRODUCT_ID_2100CHIPS     @"com.xgadget.SimpleGambleWheel.2100Chips"
#define PRODUCT_ID_3200CHIPS     @"com.xgadget.SimpleGambleWheel.3200Chips"
#define PRODUCT_ID_4400CHIPS     @"com.xgadget.SimpleGambleWheel.4400Chips"
#define PRODUCT_ID_5800CHIPS     @"com.xgadget.SimpleGambleWheel.5800Chips"
#define PRODUCT_ID_7600CHIPS     @"com.xgadget.SimpleGambleWheel.7600Chips"
#define PRODUCT_ID_9200CHIPS     @"com.xgadget.SimpleGambleWheel.9200Chips"
#define PRODUCT_ID_10400CHIPS     @"com.xgadget.SimpleGambleWheel.10400Chips"
#define PRODUCT_ID_11800CHIPS     @"com.xgadget.SimpleGambleWheel.11800Chips"
#define PRODUCT_ID_13600CHIPS     @"com.xgadget.SimpleGambleWheel.13600Chips"

#define SANDBOX			NO

#define MAX_FALSHADDIS  PLAY       15   

#define GREETING_SHOW_TIME          15

#define OFFLINE_PLAYER_TURN_DELAY       2

#define ONLINE_GAME_NONGKMASTER_CHECK_TIMELINE          10

#define ONLINE_GAME_MESSAGE_DISPLAY_TIMELINE            10

//For game object can feedback game state and type change
@protocol GameStateDelegate 
- (void)SetGameType:(int)nType theme:(int)themeType;
-(int)GetGameType;
-(void)SetGameState:(int)nState;
-(int)GetGameState;
-(void)PointerStopAt:(int)nAngle;
-(int)GetPointerPosition;
-(int)GetWinScopeIndex;
@end

//GameSeesion parent interface for handling bet winning/losing
@protocol GameControllerDelegate 
- (void)SetGameType:(int)nType theme:(int)themeType;
-(void)SetGameState:(int)nState;
-(int)GetGameType;
-(int)GetGameState;
-(int)GetGameOnlineState;
-(BOOL)IsOnline;
-(void)RegisterSubUIObject:(id)subUI;
-(void)OpenRedeemViewForPlayer:(int)nSeatID;
-(void)MakePlayerTransaction:(int)nSeatID;
-(int)GetPlayerCurrentMoney:(int)nSeat;
-(void)AddMoneyToPlayerAccount:(int)nChips inSeat:(int)nSeat;
-(BOOL)IsSystemOnHold;
-(void)SetSystemOnHold:(BOOL)bOnHold;
-(void)SpinGambleWheel:(CPinActionLevel*)action;
-(int)GetWinScopeIndex;
-(void)HandleNonSpinTouchEvent;
-(void)PlayerFinishPledge:(int)nSeat withNumber:(int)nLuckNumber withBet:(int)nBetMoney;

-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID;
-(void)GotoOfflineGame;
-(int)GetActivatedPlayerCount;

-(void)shutdownCurrentGame;
-(void)AbsoultShutDownOnlineGame;

-(void)SetGKBTPeerID:(NSString*)peerID;
-(void)SetGKBTMyID:(NSString*)myID;
-(void)AdviseGKBTSession:(GKSession*)session;
-(void)StartGKBTSessionGamePreset;        


/////////////////////////////////////////
//Start online Game
/////////////////////////////////////////
-(void)StartGKGameAsMaster:(GKMatch*)match;
-(void)StartGKGameAsParticipant:(GKMatch*)match;
-(void)AddGKPlayerToOnlineGame:(NSString*)playerID;
-(void)PopupGKMatchWindow;
-(void)StartGKMatchAutoSearch;
-(id)GetPlayerAtSeat:(int)nSeatID;
-(void)PopupGKBTSessionWindow;
-(void)PopupGKMatchWindowForPlayWith:(NSString*)szPlayerID;

-(void)CreateGKBTSession; 
-(GKSession*)GetGKBTSession; 

/////////////////////////////////////////
//AWS Online game
/////////////////////////////////////////

-(NSString*)GetInvitationSenderInitialDataString;
-(NSString*)GetInvitationRecieverInitialDataString;

@end

@protocol GameUIDelegate 
-(void)UpdateGameUI;
-(void)UpdateForGameStateChange;
-(void)UpdateForGameTypeChange;

-(void)RegisterSubUIObject:(id)subUI;
-(BOOL)CanOpenRedeemView;
-(void)MakePlayerManualPledge:(int)nSeatID;
-(void)MakePlayerTransaction:(int)nSeatID;

@end

@protocol IGameSection <NSObject>
-(void)Release;
-(int)GetGameOnlineState;
-(void)AssignController:(id<GameControllerDelegate>)controller;
-(void)InitializeDefaultPlayersConfiguration;
-(void)Draw:(CGContextRef)context inRect:(CGRect)rect;
-(void)OnTimerEvent;
-(void)OnTouchBegin:(CGPoint)pt;
-(void)OnTouchMove:(CGPoint)pt;
-(void)OnTouchEnd:(CGPoint)pt;
-(void)OnTouchCancel:(CGPoint)pt;
-(int)GetMyCurrentMoney;
-(void)AddMoneyToMyAccount:(int)nChips;
-(int)GetPlayerCurrentMoney:(int)nSeat;
-(void)AddMoneyToPlayerAccount:(int)nChips inSeat:(int)nSeat;
-(void)UpdateGameLayout;
-(void)UpdateForGameStateChange;
-(void)UpdateForGameTypeChange;
-(void)ForceClosePlayerMenus;
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
-(void)AbsoultShutDownOnlineGame;
-(void)StartGameSection;
-(id)GetPlayerAtSeat:(int)nSeatID;
-(void)OpenOnlinePlayerPopupMenu:(int)nSeatID;
-(int)GetActivatedPlayerCount;

@end

@protocol IOnlineGamePlayerPopupMenuDelegate <NSObject>
-(void)OnMenuEvent:(int)nEventID;
@end

#endif
