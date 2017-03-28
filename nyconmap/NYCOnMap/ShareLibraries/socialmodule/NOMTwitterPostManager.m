//
//  NOMTwitterPostManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-09-21.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSocialPostManager.h"
#import "NOMTwitterPostManager.h"
#import "NOMSystemConstants.h"
#import "NOMTwitterPostTask.h"
#import "NOMSocialTweetHelper.h"

@interface NOMTwitterPostManager ()
{
    NSMutableArray*         m_SharingTaskList;
    NOMSocialPostManager*   m_Parent;
}
@end

@implementation NOMTwitterPostManager

-(id)init
{
    self =[super init];
    
    if(self != nil)
    {
        m_Parent = nil;
        m_SharingTaskList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)SetParent:(NOMSocialPostManager*)parent
{
    m_Parent = parent;
}

-(void)StartSharing:(NOMNewsMetaDataRecord*)pNewsMetaData withPost:(NSString*)szPost withImage:(UIImage*)pImage toAccount:(ACAccount*)pAccount
{
    if(pAccount != nil && pNewsMetaData != nil)
    {
        NOMTwitterPostTask* pTPostTask = [[NOMTwitterPostTask alloc] init];
        [m_SharingTaskList addObject:pTPostTask];
        [pTPostTask RegisterDelegate:self];
        [pTPostTask SetAccount:pAccount];
        [pTPostTask SetLocation:pNewsMetaData.m_NewsLatitude withLongitude:pNewsMetaData.m_NewsLongitude];
        NSString* szTweet = [NOMSocialTweetHelper CreateTwitterTweet:pNewsMetaData.m_NewsMainCategory
                                                         withSubCate:pNewsMetaData.m_NewsSubCategory
                                                       withThirdCate:pNewsMetaData.m_NewsThirdCategory
                                                            withPost:szPost];
        [pTPostTask SetTweet:szTweet];
        if(pImage != nil)
        {
            [pTPostTask SetPhoto:pImage];
        }
        [pTPostTask PostTwitterTweet];
    }
}

-(void)PostTaskDone:(id)task result:(BOOL)succed
{
    if(task != nil && [task isKindOfClass:[NOMTwitterPostTask class]] == YES)
    {
        NOMTwitterPostTask* pTask = (NOMTwitterPostTask*)task;
        [m_SharingTaskList removeObject:pTask];
    }
}

-(void)StartSpotTwitterSharing:(NOMTrafficSpotRecord*)pSpot toAccount:(ACAccount*)pAccount
{
    if(pAccount != nil && pSpot != nil)
    {
        NOMTwitterPostTask* pTPostTask = [[NOMTwitterPostTask alloc] init];
        [m_SharingTaskList addObject:pTPostTask];
        [pTPostTask RegisterDelegate:self];
        [pTPostTask SetAccount:pAccount];
        [pTPostTask SetLocation:pSpot.m_SpotLatitude withLongitude:pSpot.m_SpotLongitude];
        NSString* szTweet = [NOMSocialTweetHelper CreateTwitterTweet:pSpot];
        [pTPostTask SetTweet:szTweet];
        [pTPostTask PostTwitterTweet];
    }
}
@end
