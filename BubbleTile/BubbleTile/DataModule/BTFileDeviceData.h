//
//  BTFileDeviceData.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BTFileConstant.h"
#import "GameMessage.h"

@interface BTFileDeviceData : NSObject
{
    int             m_nDeviceID;
    NSString*       m_AppVersion;
}

@property (nonatomic, readwrite, retain)NSString*       m_AppVersion;
@property (nonatomic)int                                m_nDeviceID;

-(void)Reset;
-(void)SaveDeviceIDToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)SaveAppVersionToMessage:(GameMessage*)msg withKey:(NSString*)szKey;
-(void)LoadDeviceIDFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(void)LoadAppVersionFromMessage:(NSDictionary*)msgData withKey:(NSString*)szKey;
-(BOOL)IsValid;

@end
