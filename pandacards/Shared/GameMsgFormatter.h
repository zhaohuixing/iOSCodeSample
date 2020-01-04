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
+(void)FormatStartWriteMsg:(GameMessage*)msg;
+(void)FormatStartChatMsg:(GameMessage*)msg;
+(void)FormatStopChatMsg:(GameMessage*)msg;

+(void)BeginFormatMsg:(GameMessage*)msg withMsgType:(int)nTypeID;
+(void)AddMsgText:(GameMessage*)msg withKey:(NSString*)sKey withText:(NSString*)sText;
+(void)AddMsgInt:(GameMessage*)msg withKey:(NSString*)sKey withInteger:(int)nNumber;
+(void)AddMsgFloat:(GameMessage*)msg withKey:(NSString*)sKey withFloat:(float)fNumber;
+(void)AddMsgArray:(GameMessage*)msg withKey:(NSString*)sKey withArray:(NSArray*)array;
+(void)AddMsgDictionary:(GameMessage*)msg withKey:(NSString*)sKey withDictionary:(NSDictionary*)dict;
+(void)EndFormatMsg:(GameMessage*)msg;

@end
