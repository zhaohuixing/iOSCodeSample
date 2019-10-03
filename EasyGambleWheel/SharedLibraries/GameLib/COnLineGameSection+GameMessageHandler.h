//
//  COnLineGameSection+GameMessageHandler.h
//  SimpleGambleWheel
//
//  Created by Zhaohui Xing on 12-03-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "COnLineGameSection.h"

@interface COnLineGameSection (GameMessageHandler)

-(NSString*)GetPlayerMsgKey:(int)nSeat;
-(void)handleTextMessage:(NSString*)szText fromPlayer:(NSString*)playerID;
-(void)handlePlayersOrderMessage:(NSDictionary*)msgData;
-(void)handleGameSetttingMessage:(NSDictionary*)msgData;
-(void)handlePlayerBalanceMessage:(NSDictionary*)msgData;
-(void)handlePlayerPledgeBetMessage:(NSDictionary*)msgData;
-(void)handleNextPlayTurnMessage:(NSDictionary*)msgData;
-(void)handlePlayerStateChangeMessage:(NSDictionary*)msgData;
-(void)handlePlayerPlayablityChangeMessage:(NSDictionary*)msgData;

-(void)handleChipTransferMessage:(NSDictionary*)msgData fromPlayer:(NSString*)playerID;
-(void)handleChipTransferReceiptMessage;
-(void)handleSpinGambleWheelMessage:(NSDictionary*)msgData;

@end
