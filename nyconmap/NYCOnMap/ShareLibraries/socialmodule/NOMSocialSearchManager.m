//
//  NOMSocialSearchManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-10-02.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMSocialSearchManager.h"
#import "NOMTwitterSearchManager.h"

@interface NOMSocialSearchManager ()
{
    NOMTwitterSearchManager*        m_TwitterSearchManager;
    id<INOMSoicalSearchDelegate>    m_Delegate;
}

@end

@implementation NOMSocialSearchManager

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_TwitterSearchManager = [[NOMTwitterSearchManager alloc] init];
        [m_TwitterSearchManager SetParent:self];
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMSoicalSearchDelegate>)delgate
{
    m_Delegate = delgate;
}

-(void)SearchTwitter:(int16_t)nMainCate withSubCate:(int16_t)nSubCate withThirdCate:(int16_t)nThirdCate withAccount:(ACAccount*)account fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd
{
    [m_TwitterSearchManager Search:nMainCate withSubCate:nSubCate withThirdCate:nThirdCate withAccount:account fromTime:timeStart toTime:timeEnd];
}

-(void)SearchTwitter:(int16_t)nMainCate withAccount:(ACAccount*)account fromTime:(int64_t)timeStart toTime:(int64_t)timeEnd
{
    [m_TwitterSearchManager Search:nMainCate withAccount:account fromTime:timeStart toTime:timeEnd];
}

-(void)HandleSearchResult:(id)result
{
    if(m_Delegate != nil)
    {
        [m_Delegate HandleSearchResult:result];
    }
}

-(void)HandleSearchCompletion:(NSArray*)dataArray
{
    if(m_Delegate != nil)
    {
        [m_Delegate HandleSoicalSearchToWatch:dataArray];
    }
}

@end
