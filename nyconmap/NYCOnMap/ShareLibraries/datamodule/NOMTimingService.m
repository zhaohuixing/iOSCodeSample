//
//  NOMTimingService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-11-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMTimingService.h"
#import "NOMSystemConstants.h"
#include <time.h>

@interface NOMTimingService ()
{
    NSMutableArray*             m_RecipientList;
    NSTimer*                    m_Timer;
}

@end

@implementation NOMTimingService

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_RecipientList = [[NSMutableArray alloc] init];
        m_Timer = nil;
    }
    
    return self;
}

-(void)OnTimerEvent:(NSTimer*)timer
{
    if(m_RecipientList && 0 < m_RecipientList.count)
    {
        for(int i = 0; i < (int)m_RecipientList.count; ++i)
        {
            id<INOMTimingServiceRecipient> recipient = [m_RecipientList objectAtIndex:i];
            if(recipient != nil)
                [recipient OnUnitTimingEvent];
        }
    }
}

-(void)Initialize
{
    if(m_Timer == nil)
    {
        srandom((int)time(0));
        m_Timer = [NSTimer scheduledTimerWithTimeInterval:UNITTIMING_TIMER_INTERVAL
                                                   target:self
                                                 selector:@selector(OnTimerEvent:)
                                                 userInfo:nil
                                                  repeats: YES
                   ];
    }
}

-(void)Release
{
    if(m_Timer != nil)
    {
        [m_Timer invalidate];
        m_Timer = nil;
    }
    [m_RecipientList removeAllObjects];
}

-(void)RegisterServiceRecipient:(id<INOMTimingServiceRecipient>)recipient
{
    [m_RecipientList addObject:recipient];
}

@end
