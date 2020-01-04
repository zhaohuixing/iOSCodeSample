//
//  BTFileHeader.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BTFileHeader.h"
#import "ApplicationConfigure.h"

@implementation BTFileHeader

@synthesize                 m_OriginalFileName;
@synthesize                 m_CreationTime;
@synthesize                 m_LastUpdateTime;
@synthesize                 m_AutherData;
@synthesize                 m_DeviceData;
@synthesize                 m_GameData;



-(id)init
{
    self = [super init];
    if(self)
    {
        m_OriginalFileName = @"N/A";
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        m_CreationTime = [dateFormatter stringFromDate:[NSDate date]];
        m_LastUpdateTime = [dateFormatter stringFromDate:[NSDate date]];
        m_AutherData = nil;
        m_DeviceData = nil;
        m_GameData = nil;
    }
    return self;
}

-(void)dealloc
{
    if(m_AutherData)
    {
        [m_AutherData release];
    }
    if(m_DeviceData)
    {
        [m_DeviceData release];
    }
    if(m_GameData)
    {
        [m_GameData release];
    }
    [super dealloc];
}

/*
+(id)CreateEmptyFileHeader;
+(id)CreateFileHeaderFromSource:(NSDictionary*)msgData;
*/

-(void)SetCreateTime
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease]; 
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    m_CreationTime = [dateFormatter stringFromDate:[NSDate date]];
}

-(void)SetLastUpdateTime:(NSString*)szTime
{
    m_LastUpdateTime = [szTime copy];
}

-(void)SetLastUpdateTime
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    m_LastUpdateTime = [dateFormatter stringFromDate:[NSDate date]];
}

-(void)SetFileName:(NSString*)fileName
{
    m_OriginalFileName = [fileName copy];
}

-(void)SetGamePlayer:(BTFilePlayerData*)player
{
    if(m_AutherData)
    {
        [m_AutherData release];
    }
    m_AutherData = player;
}

-(void)SetDeviceData:(BTFileDeviceData*)deviceData
{
    if(m_DeviceData)
    {
        [m_DeviceData release];
    }
    m_DeviceData = deviceData;
}

-(void)SetGameData:(BTFileGameData*)gameData
{
    if(m_GameData)
    {
        [m_GameData release];
    }
    m_GameData = gameData;
}

-(void)SaveGeneralInformationToMessage:(GameMessage*)msg
{
    if(msg == nil)
        return;
    
    [msg AddMessage:BTF_ORIGINAL_FILE_NAME withString:m_OriginalFileName];
    [msg AddMessage:BTF_ORIGINAL_TIME withString:m_CreationTime];
    [msg AddMessage:BTF_LASTPLAY_TIME withString:m_LastUpdateTime];
}

-(void)SaveAuthorToMessage:(GameMessage*)msg
{
    if(msg == nil || m_AutherData == nil)
        return;
    
    [m_AutherData SaveAutherToMessage:msg withKey:BTF_ORIGINAL_CREATOR];
    [m_AutherData SaveEmailToMessage:msg withKey:BTF_ORIGINAL_EMAIL];
    [m_AutherData SaveLocationEnableToMessage:msg withKey:BTF_ORIGINAL_GPSENABLE];
    [m_AutherData SaveLatitudeToMessage:msg withKey:BTF_ORIGINAL_LOCATIONGPSX];
    [m_AutherData SaveLongitudeToMessage:msg withKey:BTF_ORIGINAL_LOCATIONGPSY];
}

-(void)SaveDeviceToMessage:(GameMessage*)msg
{
    if(msg == nil || m_DeviceData == nil)
        return;
    
    [m_DeviceData SaveDeviceIDToMessage:msg withKey:BTF_ORIGINAL_DEVICE];
    [m_DeviceData SaveAppVersionToMessage:msg withKey:BTF_ORIGINAL_VERSION];
}

-(void)SaveGameToMessage:(GameMessage*)msg
{
    if(msg == nil || m_GameData == nil)
        return;
    
    [m_GameData SaveToMessage:msg];
}

-(void)SaveToMessage:(GameMessage*)msg
{
    [self SaveGeneralInformationToMessage:msg];
    [self SaveAuthorToMessage:msg];
    [self SaveDeviceToMessage:msg];
    [self SaveGameToMessage:msg];
}

-(void)LoadGeneralInformationFromMessage:(NSDictionary*)msgData
{
    if(msgData == nil)
        return;
    
    m_OriginalFileName = [[msgData valueForKey:BTF_ORIGINAL_FILE_NAME] copy];
    m_CreationTime = [[msgData valueForKey:BTF_ORIGINAL_TIME] copy];
    m_LastUpdateTime = [[msgData valueForKey:BTF_LASTPLAY_TIME] copy];
}

-(void)LoadAuthorFromMessage:(NSDictionary*)msgData
{
    if(msgData == nil)
        return;

    if(m_AutherData == nil)
    {
        m_AutherData = [[BTFilePlayerData alloc] init];
    }

    [m_AutherData LoadAutherFromMessage:msgData withKey:BTF_ORIGINAL_CREATOR];
    [m_AutherData LoadEmailFromMessage:msgData withKey:BTF_ORIGINAL_EMAIL];
    [m_AutherData LoadLocationEnableToMessage:msgData withKey:BTF_ORIGINAL_GPSENABLE];
    [m_AutherData LoadLatitudeFromMessage:msgData withKey:BTF_ORIGINAL_LOCATIONGPSX];
    [m_AutherData LoadLongitudeFromMessage:msgData withKey:BTF_ORIGINAL_LOCATIONGPSY];
}

-(void)LoadDeviceFromMessage:(NSDictionary*)msgData
{
    if(msgData == nil)
        return;

    if(m_DeviceData == nil)
    {
        m_DeviceData = [[BTFileDeviceData alloc] init];
    }
    [m_DeviceData LoadDeviceIDFromMessage:msgData withKey:BTF_ORIGINAL_DEVICE];
    [m_DeviceData LoadAppVersionFromMessage:msgData withKey:BTF_ORIGINAL_VERSION];
}

-(void)LoadGameFromMessage:(NSDictionary*)msgData
{
    if(msgData == nil)
        return;

    if(m_GameData == nil)
    {
        m_GameData = [[BTFileGameData alloc] init];
    }
    [m_GameData LoadFromMessage:msgData];
}


-(void)LoadFromMessage:(NSDictionary*)msgData
{
    [self LoadGeneralInformationFromMessage:msgData];
    [self LoadAuthorFromMessage:msgData];
    [self LoadDeviceFromMessage:msgData];
    [self LoadGameFromMessage:msgData];
}

+(id)CreateEmptyFileHeader
{
    BTFileHeader* BTHeader = [[BTFileHeader alloc] init];
    return BTHeader;
}

+(id)CreateFileHeaderFromSource:(NSDictionary*)msgData
{
    BTFileHeader* BTHeader = [[BTFileHeader alloc] init];
    [BTHeader LoadFromMessage:msgData];
    return BTHeader;
}

-(BOOL)IsVaid
{
    BOOL bRet = (m_GameData && [m_GameData IsValid] && m_DeviceData && [m_DeviceData IsValid]);
    return bRet;
}

+(void)AssemnleDefaultPlayerCacheDataMessage:(NSMutableDictionary**)msgData
{
    if(msgData && *msgData)
    {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* creationTime = [dateFormatter stringFromDate:[NSDate date]];
        NSString* updateTime = [dateFormatter stringFromDate:[NSDate date]];
        [(*msgData) setObject:[NSString stringWithFormat:@"%@", BT_GAMECACHE_FILENAME] forKey:BTF_ORIGINAL_FILE_NAME];
        [(*msgData) setObject:creationTime forKey:BTF_ORIGINAL_TIME];
        [(*msgData) setObject:updateTime forKey:BTF_LASTPLAY_TIME];
      
        [(*msgData) setObject:[ApplicationConfigure GetDeviceName] forKey:BTF_ORIGINAL_CREATOR];
        [(*msgData) setObject:[NSString stringWithFormat:@"HumanBeing@Earth.Universe"] forKey:BTF_ORIGINAL_EMAIL];
        int nDeiveID = [ApplicationConfigure GetDeviceID];
        NSNumber* deviceID = [[[NSNumber alloc] initWithInt:nDeiveID] autorelease];
        [(*msgData) setObject:deviceID forKey:BTF_ORIGINAL_DEVICE];
        [(*msgData) setObject:[ApplicationConfigure GetAppVersion] forKey:BTF_ORIGINAL_VERSION];
    }
}

+(void)AssemnlePlayerNewGameDataMessage:(NSMutableDictionary**)msgData withGameInfo:(NSString*)szGameDescription
{
    if(msgData && *msgData)
    {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* creationTime = [dateFormatter stringFromDate:[NSDate date]];
        NSString* updateTime = [dateFormatter stringFromDate:[NSDate date]];
        NSString* szAuthor = [ApplicationConfigure GetDeviceName];
        NSString* szDefaultFileName = [NSString stringWithFormat:@"%@_%@_%@", szAuthor, szGameDescription, creationTime];
        
        [(*msgData) setObject:szDefaultFileName forKey:BTF_ORIGINAL_FILE_NAME];
        [(*msgData) setObject:creationTime forKey:BTF_ORIGINAL_TIME];
        [(*msgData) setObject:updateTime forKey:BTF_LASTPLAY_TIME];
        
        [(*msgData) setObject:szAuthor forKey:BTF_ORIGINAL_CREATOR];
        [(*msgData) setObject:[NSString stringWithFormat:@"HumanBeing@Earth.Universe"] forKey:BTF_ORIGINAL_EMAIL];
        int nDeiveID = [ApplicationConfigure GetDeviceID];
        NSNumber* deviceID = [[[NSNumber alloc] initWithInt:nDeiveID] autorelease];
        [(*msgData) setObject:deviceID forKey:BTF_ORIGINAL_DEVICE];
        [(*msgData) setObject:[ApplicationConfigure GetAppVersion] forKey:BTF_ORIGINAL_VERSION];
    }
}


@end
