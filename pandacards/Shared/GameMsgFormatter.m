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

+(void)AddMsgArray:(GameMessage*)msg withKey:(NSString*)sKey withArray:(NSArray*)array
{
    [msg AddMessage:sKey withArray:array];
}

+(void)AddMsgDictionary:(GameMessage*)msg withKey:(NSString*)sKey withDictionary:(NSDictionary*)dict
{
    [msg AddMessage:sKey withDictionary:dict];
}

+(void)EndFormatMsg:(GameMessage*)msg
{
    [msg FormatMessage];
}


@end
