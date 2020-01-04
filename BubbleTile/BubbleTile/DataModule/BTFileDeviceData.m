//
//  BTFileDeviceData.m
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BTFileDeviceData.h"

@implementation BTFileDeviceData
@synthesize        m_AppVersion;
@synthesize        m_nDeviceID;

-(id)init
{
    self = [super init];
    if(self)
    {
        m_AppVersion = @"N/A";
        m_nDeviceID = -1;
    }
    return self;
}


-(void)Reset
{
    m_AppVersion = @"N/A";
    m_nDeviceID = -1;
}

-(void)SaveDeviceIDToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        NSNumber* msgDeviceID = [[[NSNumber alloc] initWithFloat:m_nDeviceID] autorelease]; 
        [msg AddMessage:szKey withNumber:msgDeviceID];
    }
}

-(void)SaveAppVersionToMessage:(GameMessage*)msg withKey:(NSString*)szKey
{
    if(msg)
    {
        [msg AddMessage:szKey withString:m_AppVersion];
    }
}

-(void)LoadDeviceIDFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        NSNumber* msgDeviceID = [msgData valueForKey:szKey];
        if(msgDeviceID != nil)
        {
            m_nDeviceID = [msgDeviceID intValue];
        }
        else
        {
            m_nDeviceID = -1;
        }
    }    
}

-(void)LoadAppVersionFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey
{
    if(msgData)
    {
        m_AppVersion = [[msgData valueForKey:szKey] copy];
    }
}

-(BOOL)IsValid
{
    BOOL bRet = NO;
    if(-1 < m_nDeviceID)
        bRet = YES;
    return bRet;
}

@end
