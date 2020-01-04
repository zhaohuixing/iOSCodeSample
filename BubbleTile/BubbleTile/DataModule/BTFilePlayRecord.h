//
//  BTFilePlayRecord.h
//  BubbleTile
//
//  Created by Zhaohui Xing on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BTFilePlayerData.h"
#import "BTFileDeviceData.h"

@interface BTFilePlayRecord : NSObject
{
    NSString*               m_PlayerTime;
    BTFilePlayerData*       m_PlayerData;
    BTFileDeviceData*       m_DeviceData;
    BOOL                    m_bCompleted;
    NSMutableArray*         m_PlaySteps;
}

@property (nonatomic, readonly, retain)NSString*                m_PlayerTime;
@property (nonatomic, readonly, retain)BTFilePlayerData*        m_PlayerData;
@property (nonatomic, readonly, retain)BTFileDeviceData*        m_DeviceData;
@property (nonatomic)BOOL                                       m_bCompleted;
@property (nonatomic, readonly, retain)NSMutableArray*          m_PlaySteps;


//-(void)SetPlayRecord:(BTFilePlayerData*)player device:(BTFileDeviceData*)deviceData playstep:(NSArray*)playStep completion:(BOOL)bCompleted;
-(void)SaveToMessage:(GameMessage*)msg withIndex:(int)nIndex;
-(void)LoadFromMessage:(NSDictionary*)msgData withIndex:(int)nIndex;

+(id)CreateEmptyPlayRecord;
+(id)CreatePlayRecordFromSource:(NSDictionary*)msgData withIndex:(int)nIndex;
+(void)AssemnleDefaultPlayRecordDataMessage:(NSMutableDictionary**)msgData completionState:(BOOL)bCompleted withPrefIndex:(int)nIndex;

@end
