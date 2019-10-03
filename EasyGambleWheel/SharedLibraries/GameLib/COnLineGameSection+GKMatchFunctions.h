//
//  COnLineGameSection+GKMatchFunctions.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "COnLineGameSection.h"
#import "GameMessage.h"

@interface COnLineGameSection (GKMatchFunctions)

- (void)sendOnlineMessageToAllPlayers:(GameMessage*)msg;
- (void)sendOnlineMessage:(GameMessage*)msg toPlayer:(NSString*)playerID;
- (void)translateGKMessageInformation:(NSData *)data fromPlayer:(NSString *)playerID;


-(void)SendMessageToAllPlayers:(GameMessage*)msg;
-(void)SendMessage:(GameMessage*)msg toPlayer:(NSString*)playerID;

-(void)ConnectAppleGameCenter:(GKMatch*)match;

-(void)LoadGameCenterPlayers;

-(void)SynchonzePlayersOrder;
-(void)PostOnlineGamePlayersOrder;
-(void)PostOnlineGameSettting;
-(void)PostMyOnlineGameBalance;
-(void)PostMyOnlineGameBet;
-(void)PostMyOnlineGameState;
-(void)PostMyOnlinePlayablity;
-(void)PostCancelCurrentBetMessage;
-(void)PostChipTransferMessage:(int)nTransferChips receiverID:(NSString*)szPlayerID;
-(void)PostChipTransferReceiptMessage:(NSString*)szMoneySenderID;
-(void)PostSpinGambleWheelMessage:(CPinActionLevel*)action;

-(void)LoadOnlineGamePlayersInfo;
-(BOOL)IsMakeOnlineGameBet;


-(void)SendNextPlayTurnMessage;

-(void)OnSendMyTextMessage;

-(void)CreateGKBTSession;
-(GKSession*)GetGKBTSession;

-(void)ResetGKBluetoothSession;

-(void)SetGKBTPeerID:(NSString*)peerID;
-(void)SetGKBTMyID:(NSString*)myID;
-(void)AdviseGKBTSession:(GKSession*)session;
-(void)LoadGKBTSessionPlayerInformation;

@end
