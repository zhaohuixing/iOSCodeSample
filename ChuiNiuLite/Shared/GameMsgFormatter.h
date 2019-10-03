//
//  GameMsgFormatter.h
//  XXXXX
//
//  Created by Zhaohui Xing on 2011-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameMessage.h"

@interface GameMsgFormatter : NSObject

+(void)FormatTextMsg:(GameMessage*)msg withText:(NSString*)szText;
//+(void)FormatCompassMsg:(GameMessage*)msg withCompass:(int)nCompassType;
//+(void)FormatPinMsg:(GameMessage*)msg withPin:(int)nPinType;
//+(void)FormatActionMsg:(GameMessage*)msg withAction:(CPinActionLevel*)pAction;
+(void)FormatStartWriteMsg:(GameMessage*)msg;
+(void)FormatStartChatMsg:(GameMessage*)msg;
+(void)FormatStopChatMsg:(GameMessage*)msg;
//+(void)FormatNextTurnMsg:(GameMessage*)msg nextPlayer:(NSString*)szPlayerID;

+(void)BeginFormatMsg:(GameMessage*)msg withMsgType:(int)nTypeID;
+(void)AddMsgText:(GameMessage*)msg withKey:(NSString*)sKey withText:(NSString*)sText;
+(void)AddMsgInt:(GameMessage*)msg withKey:(NSString*)sKey withInteger:(int)nNumber;
+(void)AddMsgFloat:(GameMessage*)msg withKey:(NSString*)sKey withFloat:(float)fNumber;
+(void)EndFormatMsg:(GameMessage*)msg;

@end
