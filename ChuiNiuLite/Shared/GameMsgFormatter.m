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
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_TEXT] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg AddMessage:GAME_MSG_KEY_TEXTMSG withString:szText];
    [msg FormatMessage];
}

/*+(void)FormatCompassMsg:(GameMessage*)msg withCompass:(int)nCompassType
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_COMPASSTYPE] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    NSNumber* msgCompass = [[[NSNumber alloc] initWithInt:nCompassType] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_COMPASSMSG withNumber:msgCompass];
    [msg FormatMessage];
}

+(void)FormatPinMsg:(GameMessage*)msg withPin:(int)nPinType
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_PINTYPE] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    NSNumber* msgPin = [[[NSNumber alloc] initWithInt:nPinType] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_PIN withNumber:msgPin];
    [msg FormatMessage];
}

+(void)FormatActionMsg:(GameMessage*)msg withAction:(CPinActionLevel*)pAction
{
    if(pAction == NULL)
        return;

    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_ACTIONLEVEL] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    
    NSNumber* msgFast = [[[NSNumber alloc] initWithInt:pAction->m_nFastCycle] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_FASTCYCLE withNumber:msgFast];

    NSNumber* msgMedium = [[[NSNumber alloc] initWithInt:pAction->m_nMediumCycle] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_MEDIUMCYCLE withNumber:msgMedium];

    NSNumber* msgSlow = [[[NSNumber alloc] initWithInt:pAction->m_nSlowCycle] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_SLOWCYCLE withNumber:msgSlow];

    NSNumber* msgAngle = [[[NSNumber alloc] initWithInt:pAction->m_nSlowAngle] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_SLOWANGLE withNumber:msgAngle];

    NSNumber* msgVib = [[[NSNumber alloc] initWithInt:pAction->m_nVibCycle] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_VIBCYCLE withNumber:msgVib];

    NSNumber* msgClockwise = [[[NSNumber alloc] initWithInt:pAction->m_bClockwise] autorelease]; 
    [msg AddMessage:GAME_MSG_KEY_ACTION_CLOCKWISE withNumber:msgClockwise];
    
    [msg FormatMessage];
}*/

+(void)FormatStartWriteMsg:(GameMessage*)msg
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_STARTWRITTING] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg FormatMessage];
}

+(void)FormatStartChatMsg:(GameMessage*)msg
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_STARTCHATTING] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg FormatMessage];
}

+(void)FormatStopChatMsg:(GameMessage*)msg
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_STOPCHATTING] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg FormatMessage];
}

/*
+(void)FormatNextTurnMsg:(GameMessage*)msg nextPlayer:(NSString*)szPlayerID
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:GAME_MSG_TYPE_GAMEPLAYNEXTTURN] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
    [msg AddMessage:GAME_MSG_KEY_GAMENEXTTURN_ID withString:szPlayerID];
    [msg FormatMessage];
   
}*/


+(void)BeginFormatMsg:(GameMessage*)msg withMsgType:(int)nTypeID
{
    NSNumber* msgType = [[[NSNumber alloc] initWithInt:nTypeID] autorelease];
    [msg AddMessage:GAME_MSG_KEY_TYPE withNumber:msgType];
}

+(void)AddMsgText:(GameMessage*)msg withKey:(NSString*)sKey withText:(NSString*)sText
{
    [msg AddMessage:sKey withString:sText];
}

+(void)AddMsgInt:(GameMessage*)msg withKey:(NSString*)sKey withInteger:(int)nNumber
{
    NSNumber* msgInt = [[[NSNumber alloc] initWithInt:nNumber] autorelease]; 
    [msg AddMessage:sKey withNumber:msgInt];
}

+(void)AddMsgFloat:(GameMessage*)msg withKey:(NSString*)sKey withFloat:(float)fNumber
{
    NSNumber* msgFloat = [[[NSNumber alloc] initWithFloat:fNumber] autorelease]; 
    [msg AddMessage:sKey withNumber:msgFloat];
}

+(void)EndFormatMsg:(GameMessage*)msg
{
    [msg FormatMessage];
}


@end
