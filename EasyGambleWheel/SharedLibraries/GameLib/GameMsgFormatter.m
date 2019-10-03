//
//  GameMsgFormatter.m
//  XXXXXXXX
//
//  Created by Zhaohui Xing on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GameMsgFormatter.h"
#import "GameMsgConstant.h"

@implementation GameMsgFormatter

+(void)FormatTextMsg:(GameMessage*)msg withText:(NSString*)szText
{
    NSNumber* msgType = [[NSNumber alloc] initWithInt:GAME_MSG_TYPE_TEXT];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg AddMessage:GAME_MSG_KEY_TEXTMSG withString:szText];
    [msg FormatMessage];
}

+(void)FormatActionMsg:(GameMessage*)msg withAction:(CPinActionLevel*)pAction
{
    if(pAction == NULL)
        return;

    NSNumber* msgType = [[NSNumber alloc] initWithInt:GAME_MSG_TYPE_ACTIONLEVEL];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    
    NSNumber* msgFast = [[NSNumber alloc] initWithInt:pAction.m_nFastCycle]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_FASTCYCLE withNumber:msgFast];

    NSNumber* msgMedium = [[NSNumber alloc] initWithInt:pAction.m_nMediumCycle]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_MEDIUMCYCLE withNumber:msgMedium];

    NSNumber* msgSlow = [[NSNumber alloc] initWithInt:pAction.m_nSlowCycle]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_SLOWCYCLE withNumber:msgSlow];

    NSNumber* msgAngle = [[NSNumber alloc] initWithInt:pAction.m_nSlowAngle]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_SLOWANGLE withNumber:msgAngle];

    NSNumber* msgVib = [[NSNumber alloc] initWithInt:pAction.m_nVibCycle]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_VIBCYCLE withNumber:msgVib];

    NSNumber* msgClockwise = [[NSNumber alloc] initWithInt:pAction.m_bClockwise]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_CLOCKWISE withNumber:msgClockwise];
    
    [msg FormatMessage];
}

+(void)FormatStartWriteMsg:(GameMessage*)msg
{
    NSNumber* msgType = [[NSNumber alloc] initWithInt:GAME_MSG_TYPE_STARTWRITTING];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg FormatMessage];
}

+(void)FormatStartChatMsg:(GameMessage*)msg
{
    NSNumber* msgType = [[NSNumber alloc] initWithInt:GAME_MSG_TYPE_STARTCHATTING];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg FormatMessage];
}

+(void)FormatStopChatMsg:(GameMessage*)msg
{
    NSNumber* msgType = [[NSNumber alloc] initWithInt:GAME_MSG_TYPE_STOPCHATTING];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg FormatMessage];
}

+(void)FormatNextTurnMsg:(GameMessage*)msg nextPlayer:(NSString*)szPlayerID
{
    NSNumber* msgType = [[NSNumber alloc] initWithInt:GAME_MSG_TYPE_GAMEPLAYNEXTTURN];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg AddMessage:GAME_MSG_KEY_GAMENEXTTURN_ID withString:szPlayerID];
    [msg FormatMessage];
   
}


+(void)BeginFormatMsg:(GameMessage*)msg withMsgType:(int)nTypeID
{
    NSNumber* msgType = [[NSNumber alloc] initWithInt:nTypeID];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
}

+(void)AddMsgText:(GameMessage*)msg withKey:(NSString*)sKey withText:(NSString*)sText
{
    [msg AddMessage:sKey withString:sText];
}

+(void)AddMsgInt:(GameMessage*)msg withKey:(NSString*)sKey withInteger:(int)nNumber
{
    NSNumber* msgInt = [[NSNumber alloc] initWithInt:nNumber]; 
    [msg AddMessage:sKey withNumber:msgInt];
}

+(void)AddMsgFloat:(GameMessage*)msg withKey:(NSString*)sKey withFloat:(float)fNumber
{
    NSNumber* msgFloat = [[NSNumber alloc] initWithFloat:fNumber]; 
    [msg AddMessage:sKey withNumber:msgFloat];
}

+(void)EndFormatMsg:(GameMessage*)msg
{
    [msg FormatMessage];
}

+(void)FormatPlayerBetMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID luckNumber:(int)nLuckNumber betAmount:(int)nBet chipBalance:(int)chipBalace
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_PLAYERBET];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_PLAIN_PLAYER_ID withText:szPlayerID];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_PLEDGET_LUCKYNUMBER withInteger:nLuckNumber];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_PLEDGET_BET withInteger:nBet];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE withInteger:chipBalace];
    [GameMsgFormatter EndFormatMsg:msg];
}

+(void)FormatPlayerBalanceMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID chipBalance:(int)chipBalace
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_PLAYERBALANCE];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_PLAIN_PLAYER_ID withText:szPlayerID];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_PLAYER_CHIPS_BALANCE withInteger:chipBalace];
    [GameMsgFormatter EndFormatMsg:msg];
}

+(void)FormatGameSettingMsg:(GameMessage*)msg gameType:(int)nGameType playTurn:(int)nPlayTurnType
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMESETTINGSYNC];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMETYPEMSG withInteger:nGameType];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_ONLINEPLAYSEQUENCE withInteger:nPlayTurnType];
    [GameMsgFormatter EndFormatMsg:msg];
}

+(void)FormatGameSettingMsg:(GameMessage*)msg gameType:(int)nGameType playTurn:(int)nPlayTurnType themeType:(int)nThemeType
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_GAMESETTINGSYNC];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_GAMETYPEMSG withInteger:nGameType];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_ONLINEPLAYSEQUENCE withInteger:nPlayTurnType];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_THEMETYPEMSG withInteger:nThemeType];
    [GameMsgFormatter EndFormatMsg:msg];
}


+(void)FormatPlayerStateMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID playerState:(int)nState
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_PLAYERSTATE];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_PLAIN_PLAYER_ID withText:szPlayerID];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_PLAYERSTATE withInteger:nState];
    [GameMsgFormatter EndFormatMsg:msg];
}

+(void)FormatChipTransferMsg:(GameMessage*)msg recieverID:(NSString*)szRecieverID chipAmount:(int)nChips
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_MONEYTRANSFER];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_MONEYRECIEVER withText:szRecieverID];
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_TRANSMONEYMOUNT withInteger:nChips];
    [GameMsgFormatter EndFormatMsg:msg];
}

+(void)FormatChipTransferReceiptMsg:(GameMessage*)msg senderID:(NSString*)szSenderID
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_MONEYTRANSFERRECEIPT];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_MONEYSENDER withText:szSenderID];
    [GameMsgFormatter EndFormatMsg:msg];
}

//May not be used
+(void)FormatPlayerPlayabilityMsg:(GameMessage*)msg playerID:(NSString*)szPlayerID Playability:(BOOL)bEnable
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_PLAYERPLAYABLITY];
    [GameMsgFormatter AddMsgText:msg withKey:GAME_MSG_KEY_PLAIN_PLAYER_ID withText:szPlayerID];
    int nEable = 0;
    if(bEnable)
        nEable = 1;
    [GameMsgFormatter AddMsgInt:msg withKey:GAME_MSG_KEY_PLAYERPLAYABLITY withInteger:nEable];
    [GameMsgFormatter EndFormatMsg:msg];
}

+(void)FormatCancelPendingBetMsg:(GameMessage*)msg
{
    [GameMsgFormatter BeginFormatMsg:msg withMsgType:GAME_MSG_TYPE_CANCELPENDINGBET];
    [GameMsgFormatter EndFormatMsg:msg];
}

@end
