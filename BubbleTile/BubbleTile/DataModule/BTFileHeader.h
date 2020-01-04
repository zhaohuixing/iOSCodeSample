//
//  BTFileHeader.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BTFilePlayerData.h"
#import "BTFileDeviceData.h"
#import "BTFileGameData.h"

@interface BTFileHeader : NSObject
{
    NSString*               m_OriginalFileName;
    NSString*               m_LastReferenceCacheFileName; //For cache file saving back original file only
    NSString*               m_CreationTime;
    NSString*               m_LastUpdateTime;
    BTFilePlayerData*       m_AutherData;
    BTFileDeviceData*       m_DeviceData;
    BTFileGameData*         m_GameData;
}

@property (nonatomic, readonly, retain)NSString*                m_OriginalFileName;
@property (nonatomic, readonly, retain)NSString*                m_CreationTime;
@property (nonatomic, readwrite, retain)NSString*               m_LastUpdateTime;
@property (nonatomic, readonly, retain)BTFilePlayerData*        m_AutherData;
@property (nonatomic, readonly, retain)BTFileDeviceData*        m_DeviceData;
@property (nonatomic, readonly, retain)BTFileGameData*          m_GameData;

+(id)CreateEmptyFileHeader;
+(id)CreateFileHeaderFromSource:(NSDictionary*)msgData;
+(void)AssemnleDefaultPlayerCacheDataMessage:(NSMutableDictionary**)msgData;
+(void)AssemnlePlayerNewGameDataMessage:(NSMutableDictionary**)msgData withGameInfo:(NSString*)szGameDescription;

-(void)SetCreateTime;
-(void)SetLastUpdateTime:(NSString*)szTime;
-(void)SetLastUpdateTime;
-(void)SetFileName:(NSString*)fileName;
-(void)SetGamePlayer:(BTFilePlayerData*)player;
-(void)SetDeviceData:(BTFileDeviceData*)deviceData;
-(void)SetGameData:(BTFileGameData*)gameData;

-(void)SaveToMessage:(GameMessage*)msg;
-(void)LoadFromMessage:(NSDictionary*)msgData;
-(BOOL)IsVaid;

@end
