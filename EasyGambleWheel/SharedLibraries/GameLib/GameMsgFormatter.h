//
//  GameMsgFormatter.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameUtiltyObjects.h"
#import "GameMessage.h"

@interface GameMsgFormatter : NSObject

+(void)FormatTextMsg:(GameMessage*)msg withText:(NSString*)szText;
+(void)FormatActionMsg:(GameMessage*)msg withAction:(CPinActionLevel*)pAction;
+(void)FormatStartWriteMsg:(GameMessage*)msg;
+(void)FormatStartChatMsg:(GameMessage*)msg;
+(void)FormatStopChatMsg:(GameMessage*)msg;
+(void)FormatNextTurnMsg:(GameMessage*)msg nextPlayer:(NSString*)szPlayerID;

+(void)BeginFormatMsg:(GameMessage*)msg withMsgType:(int)nTypeID;
+(void)AddMsgText:(GameMessage*)msg withKey:(NSString*)sKey withText:(NSString*)sText;
+(void)AddMsgInt:(GameMessage*)msg withKey:(NSString*)sKey withInteger:(int)nNumber;
+(void)AddMsgFloat:(GameMessage*)msg withKey:(NSString*)sKey withFloat:(float)fNumber;
+(void)EndFormatMsg:(GameMessage*)msg;

+(void)FormatPlayerBetMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID luckNumber:(int)nLuckNumber betAmount:(int)nBet chipBalance:(int)chipBalace;
+(void)FormatPlayerBalanceMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID chipBalance:(int)chipBalace;
+(void)FormatGameSettingMsg:(GameMessage*)msg gameType:(int)nGameType playTurn:(int)nPlayTurnType;
+(void)FormatGameSettingMsg:(GameMessage*)msg gameType:(int)nGameType playTurn:(int)nPlayTurnType themeType:(int)nThemeType;
+(void)FormatPlayerStateMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID playerState:(int)nState;
+(void)FormatChipTransferMsg:(GameMessage*)msg recieverID:(NSString*)szRecieverID chipAmount:(int)nChips;
+(void)FormatChipTransferReceiptMsg:(GameMessage*)msg senderID:(NSString*)szSenderID;
+(void)FormatPlayerPlayabilityMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID Playability:(BOOL)bEnable;
+(void)FormatCancelPendingBetMsg:(GameMessage*)msg;

@end
