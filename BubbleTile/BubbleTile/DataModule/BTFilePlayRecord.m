//
//  BTFilePlayRecord.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BTFilePlayRecord.h"
#import "ApplicationConfigure.h"

@implementation BTFilePlayRecord

@synthesize                 m_PlayerTime;
@synthesize                 m_PlayerData;
@synthesize                 m_DeviceData;
@synthesize                 m_bCompleted;
@synthesize                 m_PlaySteps;

-(id)init
{
    self = [super init];
    if(self)
    {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        m_PlayerTime = [dateFormatter stringFromDate:[NSDate date]];
        m_PlayerData = nil;
        m_DeviceData = nil;
        m_bCompleted = NO;
        m_PlaySteps = nil;
    }
    return self;
}

-(void)dealloc
{
    if(m_PlayerData)
    {
        [m_PlayerData release];
    }
    if(m_DeviceData)
    {
        [m_DeviceData release];
    }
    if(m_PlaySteps)
    {
        [m_PlaySteps removeAllObjects];
        [m_PlaySteps release];
    }
    [super dealloc];
}

/*
-(void)SetPlayRecord:(BTFilePlayerData*)player device:(BTFileDeviceData*)deviceData playstep:(NSArray*)playStep completion:(BOOL)bCompleted
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    m_PlayerTime = [dateFormatter stringFromDate:[NSDate date]];
    if(m_PlayerData)
    {
        [m_PlayerData release];
        m_PlayerData = nil;
    }
    m_PlayerData = player;
    
    if(m_DeviceData)
    {
        [m_DeviceData release];
        m_DeviceData = nil;
    }
    m_DeviceData = deviceData;
    
    if(m_PlaySteps)
    {
        [m_PlaySteps release];
        m_PlaySteps = nil;
    }
    m_PlaySteps = [[NSArray alloc] initWithArray:playStep copyItems:YES];
    m_bCompleted = bCompleted;
}
*/ 

-(void)SaveToMessage:(GameMessage*)msg withIndex:(int)nIndex
{
    NSString* szKey;

    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAY_TIME_PREFIX, nIndex];
    [msg AddMessage:szKey withString:m_PlayerTime];
    
    if(m_PlayerData)
    {
        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYER_PREFIX, nIndex];
        [m_PlayerData SaveAutherToMessage:msg withKey:szKey];
        
        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_EMAIL_PREFIX, nIndex];
        [m_PlayerData SaveEmailToMessage:msg withKey:szKey];

        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_GPSENABLE_PREFIX, nIndex];
        [m_PlayerData SaveLocationEnableToMessage:msg withKey:szKey];  
        
        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_LOCATIONGPSX_PREFIX, nIndex];
        [m_PlayerData SaveLatitudeToMessage:msg withKey:szKey];  

        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_LOCATIONGPSY_PREFIX, nIndex];
        [m_PlayerData SaveLongitudeToMessage:msg withKey:szKey];  
    }
        
    if(m_DeviceData)
    {
        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_DEVICE_PREFIX, nIndex];
        [m_DeviceData SaveDeviceIDToMessage:msg withKey:szKey];

        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_VERSION_PREFIX, nIndex];
        [m_DeviceData SaveAppVersionToMessage:msg withKey:szKey];
    }
    
    NSNumber* msgComplete = [[[NSNumber alloc] initWithBool:m_bCompleted] autorelease];
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STATE_PREFIX, nIndex];
    [msg AddMessage:szKey withNumber:msgComplete];
    
    
    if (m_PlaySteps) 
    {
        szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STEPS_PREFIX, nIndex];
        [msg AddMessage:szKey withArray:m_PlaySteps];
    }
}

-(void)LoadFromMessage:(NSDictionary*)msgData withIndex:(int)nIndex
{
    NSString* szKey;
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAY_TIME_PREFIX, nIndex];
    m_PlayerTime = [[msgData valueForKey:szKey] copy];
    
    if(m_PlayerData == nil)
    {
        m_PlayerData = [[BTFilePlayerData alloc] init];
    }    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYER_PREFIX, nIndex];
    [m_PlayerData LoadAutherFromMessage:msgData withKey:szKey];
        
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_EMAIL_PREFIX, nIndex];
    [m_PlayerData LoadEmailFromMessage:msgData withKey:szKey];
   
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_GPSENABLE_PREFIX, nIndex];
    [m_PlayerData LoadLocationEnableToMessage:msgData withKey:szKey];
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_LOCATIONGPSX_PREFIX, nIndex];
    [m_PlayerData LoadLatitudeFromMessage:msgData withKey:szKey];  
        
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_LOCATIONGPSY_PREFIX, nIndex];
    [m_PlayerData LoadLongitudeFromMessage:msgData withKey:szKey];  
    
    if(m_DeviceData == nil)
    {
        m_DeviceData = [[BTFileDeviceData alloc] init];
    }    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_DEVICE_PREFIX, nIndex];
    [m_DeviceData LoadDeviceIDFromMessage:msgData withKey:szKey];
        
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_VERSION_PREFIX, nIndex];
    [m_DeviceData LoadAppVersionFromMessage:msgData withKey:szKey];
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STATE_PREFIX, nIndex];
    NSNumber* msgComplete = [msgData valueForKey:szKey];
    if(msgComplete)
    {
        m_bCompleted = [msgComplete boolValue];
    }
    
    if (m_PlaySteps!= nil) 
    {
        [m_PlaySteps removeAllObjects];
        [m_PlaySteps release];
        m_PlaySteps = nil;
    }

    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STEPS_PREFIX, nIndex];
    NSMutableArray* tempArray = [msgData valueForKey:szKey];
    if(tempArray)
    {
        m_PlaySteps = [[NSMutableArray alloc] init];
        for(int i = 0; i < [tempArray count]; ++i)
        {
            NSNumber* nsInteger = [[[NSNumber alloc] initWithInt:[(NSNumber*)[tempArray objectAtIndex:i] intValue]] autorelease];
            [m_PlaySteps addObject:nsInteger];
        }
    }
}

+(id)CreateEmptyPlayRecord
{
    BTFilePlayRecord* pRecord = [[BTFilePlayRecord alloc] init];
    return pRecord;
}

+(id)CreatePlayRecordFromSource:(NSDictionary*)msgData withIndex:(int)nIndex
{
    BTFilePlayRecord* pRecord = [[BTFilePlayRecord alloc] init];
    [pRecord LoadFromMessage:msgData withIndex:nIndex];
    return pRecord;
}

+(void)AssemnleDefaultPlayRecordDataMessage:(NSMutableDictionary**)msgData completionState:(BOOL)bCompleted withPrefIndex:(int)nIndex
{
    NSString* szKey;
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAY_TIME_PREFIX, nIndex];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* creationTime = [dateFormatter stringFromDate:[NSDate date]];
    [(*msgData) setObject:creationTime forKey:szKey];
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYER_PREFIX, nIndex];
    [(*msgData) setObject:[ApplicationConfigure GetDeviceName] forKey:szKey];
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_EMAIL_PREFIX, nIndex];
    [(*msgData) setObject:[NSString stringWithFormat:@"HumanBeing@Earth.Universe"] forKey:szKey];
    
    int nDeiveID = [ApplicationConfigure GetDeviceID];
    NSNumber* deviceID = [[[NSNumber alloc] initWithInt:nDeiveID] autorelease];
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_DEVICE_PREFIX, nIndex];
    [(*msgData) setObject:deviceID forKey:szKey];
    
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_VERSION_PREFIX, nIndex];
    [(*msgData) setObject:[ApplicationConfigure GetAppVersion] forKey:szKey];

    NSNumber* msgComplete = [[[NSNumber alloc] initWithBool:bCompleted] autorelease];
    szKey = [NSString stringWithFormat:@"%@%i", BTF_RECORD_PLAYING_STATE_PREFIX, nIndex];
    [(*msgData) setObject:msgComplete forKey:szKey];
}


@end
