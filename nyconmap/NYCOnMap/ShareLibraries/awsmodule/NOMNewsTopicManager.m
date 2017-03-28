//
//  NOMNewsTopicManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsTopicManager.h"
#import "NOMOperationManager.h"
/*
#import "NOMTrafficTopicPostService.h"

*/ 
#import "NOMAppInfo.h"
#import "NOMPreference.h"
#import "NOMAppRegionHelper.h"
#import "NOMNewsMobileEndPointARNCreateService.h"
#import "NOMNewsMobileDeviceSubscribeService.h"
#import "NOMNewsTopicSearchService.h"
#import "NOMNewsTopicCreateService.h"
#import "AmazonClientManager.h"

@interface NOMNewsTopicManager()
{
    NSMutableArray*                 m_TrafficTopicServiceManager;
    AmazonSNSClient*                m_MessagePostService;
    
    NSString*                       m_TrafficTopicARN;
    NSString*                       m_TrafficTopicName;
    
    NSString*                       m_TaxiTopicARN;
    NSString*                       m_TaxiTopicName;
    
    NSString*                       m_EndPointARN;
 
    id<NOMNewsTopicDelegate>     m_Delegate;
}

//-(void)CreateTopic;
-(void)SubscribeMobileDeviceToTrafficTopic;
-(void)SubscribeMobileDeviceToTaxiTopic;

-(BOOL)IsTrafficTopicARN:(NSString*)trafficARN;
-(BOOL)IsTrafficTopicName:(NSString*)trafficName;

-(BOOL)IsTaxiTopicARN:(NSString*)taxiARN;
-(BOOL)IsTaxiTopicName:(NSString*)taxiName;

@end


@implementation NOMNewsTopicManager

-(BOOL)IsTrafficTopicARN:(NSString*)trafficARN
{
    BOOL bRet = NO;
    
    if(m_TrafficTopicARN != nil && [m_TrafficTopicARN isEqualToString:trafficARN] == YES)
        bRet = YES;
    
    return bRet;
}

-(BOOL)IsTrafficTopicName:(NSString*)trafficName
{
    BOOL bRet = NO;
    
    if(m_TrafficTopicName != nil && [m_TrafficTopicName isEqualToString:trafficName] == YES)
        bRet = YES;
    
    return bRet;
}

-(BOOL)IsTaxiTopicARN:(NSString*)taxiARN
{
    BOOL bRet = NO;
    
    if(m_TaxiTopicARN != nil && [m_TaxiTopicARN isEqualToString:taxiARN] == YES)
        bRet = YES;
    
    return bRet;
}

-(BOOL)IsTaxiTopicName:(NSString*)taxiName
{
    BOOL bRet = NO;
    
    if(m_TaxiTopicName != nil && [m_TaxiTopicName isEqualToString:taxiName] == YES)
        bRet = YES;
    
    return bRet;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_TrafficTopicServiceManager = [[NSMutableArray alloc] init];
        m_MessagePostService = [AmazonClientManager CreateSNSClient];
        m_TrafficTopicARN = nil;
        m_EndPointARN = nil;
        m_TrafficTopicName = nil; //[NOMAppRegionHelper GetCurrentRegionTrafficTopicName];

        m_TaxiTopicARN = nil;
        m_TaxiTopicName = nil;
        
        m_Delegate = nil;
    }
    
    return self;
}

-(id)initWithTopicName:(NSString*)szTopic
{
    self = [super init];
    
    if(self != nil)
    {
        m_TrafficTopicServiceManager = [[NSMutableArray alloc] init];
        m_MessagePostService = [AmazonClientManager CreateSNSClient];
        m_TrafficTopicARN = nil;
        m_EndPointARN = nil;
        m_TrafficTopicName = szTopic;

        m_TaxiTopicARN = nil;
        m_TaxiTopicName = nil;
        
        m_Delegate = nil;
    }
    
    return self;
}

-(id)initWithTrafficTopicName:(NSString*)szTrafficTopic withTaxiTopicName:(NSString*)szTaxiTopic
{
    self = [super init];
    
    if(self != nil)
    {
        m_TrafficTopicServiceManager = [[NSMutableArray alloc] init];
        m_MessagePostService = [AmazonClientManager CreateSNSClient];
        m_TrafficTopicARN = nil;
        m_EndPointARN = nil;
        m_TrafficTopicName = szTrafficTopic;
        
        m_TaxiTopicARN = nil;
        m_TaxiTopicName = szTaxiTopic;
        
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<NOMNewsTopicDelegate>)delegate
{
    m_Delegate = delegate;
}

-(NSString*)GetTrafficTopicARN
{
    return m_TrafficTopicARN;
}

-(NSString*)GetTrafficTopicName
{
    return m_TrafficTopicName;
}

-(NSString*)GetTaxiTopicARN
{
    return m_TaxiTopicARN;
}

-(NSString*)GetTaxiTopicName
{
    return m_TaxiTopicName;
}

-(NSString*)GetEndPointARN
{
    return m_EndPointARN;
}


-(AmazonSNSClient*)GetSNSClient
{
    return m_MessagePostService;
}

-(void)HookupTrafficTopic
{
    NOMNewsTopicSearchService* findTopicARN = [[NOMNewsTopicSearchService alloc] initWithSNSClient:m_MessagePostService withTopic:m_TrafficTopicName];
    [findTopicARN RegisterDelegate:self];
    [m_TrafficTopicServiceManager addObject:findTopicARN];
    [findTopicARN Start];
}

-(void)HookupTaxiTopic
{
    NOMNewsTopicSearchService* findTopicARN = [[NOMNewsTopicSearchService alloc] initWithSNSClient:m_MessagePostService withTopic:m_TaxiTopicName];
    [findTopicARN RegisterDelegate:self];
    [m_TrafficTopicServiceManager addObject:findTopicARN];
    [findTopicARN Start];
}

-(void)CreateTrafficTopic
{
    NOMNewsTopicCreateService* createTopicARN = [[NOMNewsTopicCreateService alloc] initWithSNSClient:m_MessagePostService withTopic:m_TrafficTopicName];
    [createTopicARN RegisterDelegate:self];
    [m_TrafficTopicServiceManager addObject:createTopicARN];
    [createTopicARN Start];
}

-(void)CreateTaxiTopic
{
    NOMNewsTopicCreateService* createTopicARN = [[NOMNewsTopicCreateService alloc] initWithSNSClient:m_MessagePostService withTopic:m_TaxiTopicName];
    [createTopicARN RegisterDelegate:self];
    [m_TrafficTopicServiceManager addObject:createTopicARN];
    [createTopicARN Start];
}

/*
-(void)CreateTopic
{
    [self CreateTrafficTopic];
}
*/ 

-(void)CreateMobilePushEndPointARN
{
    NSString* szDeviceToken = [[NOMPreference GetSharedPreference] GetAWSDeviceToken];
    if(szDeviceToken == nil)
    {
#ifdef DEBUG
        NSLog(@"CreateMobilePushEndPointARN: APSN device token is empty!");
#endif
        return;
    }
    
    NOMNewsMobileEndPointARNCreateService* createEndPointARN = [[NOMNewsMobileEndPointARNCreateService alloc] initWithSNSClient:m_MessagePostService withDeviceToken:szDeviceToken];
    [createEndPointARN RegisterDelegate:self];
    [m_TrafficTopicServiceManager addObject:createEndPointARN];
    [createEndPointARN Start];
}

-(void)SubscribeMobileDeviceToTrafficTopic
{
    if(m_TrafficTopicARN != nil && 0 < [m_TrafficTopicARN length] && m_EndPointARN != nil && 0 < [m_EndPointARN length])
    {
        NOMNewsMobileDeviceSubscribeService* mobileScribe = [[NOMNewsMobileDeviceSubscribeService alloc] initWithSNSClient:m_MessagePostService withTopic:m_TrafficTopicARN withEndPoint:m_EndPointARN];
        [mobileScribe RegisterDelegate:self];
        [m_TrafficTopicServiceManager addObject:mobileScribe];
        [mobileScribe Start];
    }
}

-(void)SubscribeMobileDeviceToTaxiTopic
{
    if(m_TaxiTopicARN != nil && 0 < [m_TaxiTopicARN length] && m_EndPointARN != nil && 0 < [m_EndPointARN length])
    {
        NOMNewsMobileDeviceSubscribeService* mobileScribe = [[NOMNewsMobileDeviceSubscribeService alloc] initWithSNSClient:m_MessagePostService withTopic:m_TaxiTopicARN withEndPoint:m_EndPointARN];
        [mobileScribe RegisterDelegate:self];
        [m_TrafficTopicServiceManager addObject:mobileScribe];
        [mobileScribe Start];
    }
}

-(void)InitializeMobilePushEndPointTrafficARN
{
    if (m_EndPointARN == nil)
    {
        m_EndPointARN = [[NOMPreference GetSharedPreference] GetAWSEndPointARN];
        if(m_EndPointARN == nil || m_EndPointARN.length <= 0)
        {
            [self CreateMobilePushEndPointARN];
        }
        else
        {
            [self SubscribeMobileDeviceToTrafficTopic];
        }
    }
    else
    {
        [self SubscribeMobileDeviceToTrafficTopic];
    }
}

-(void)InitializeMobilePushEndPointTaxiARN
{
    if (m_EndPointARN == nil)
    {
        m_EndPointARN = [[NOMPreference GetSharedPreference] GetAWSEndPointARN];
        if(m_EndPointARN == nil || m_EndPointARN.length <= 0)
        {
            [self CreateMobilePushEndPointARN];
        }
        else
        {
            [self SubscribeMobileDeviceToTaxiTopic];
        }
    }
    else
    {
        [self SubscribeMobileDeviceToTaxiTopic];
    }
}

-(void)HandleActiveRegionChanged
{
    if([NOMAppInfo IsCityBaseAppRegionOnly] == NO)
    {
        if([NOMAppRegionHelper IsCurrentMapRegionChanged] == YES)
        {
            m_TrafficTopicName = [NOMAppRegionHelper GetCurrentRegionTrafficTopicName];
            [self HookupTrafficTopic];
            
            m_TaxiTopicName = [NOMAppRegionHelper GetCurrentRegionTaxiTopicName];
            [self HookupTaxiTopic];
        }
    }
}

//
// INOMMobileEndPointARNCreationDelegate methods
//
-(void)MobileEndPointARNCreation:(id)ARNCreation result:(BOOL)bOK
{
    if(ARNCreation == nil)
        return;
    
    if([ARNCreation isKindOfClass:[NOMNewsMobileEndPointARNCreateService class]])
    {
        if(bOK == YES)
        {
            m_EndPointARN = [(NOMNewsMobileEndPointARNCreateService*)ARNCreation GetEndPointARN];
            [[NOMPreference GetSharedPreference] SetAWSEndPointARN:m_EndPointARN];
            [self SubscribeMobileDeviceToTrafficTopic];
            [self SubscribeMobileDeviceToTaxiTopic];
        }
    }
    [m_TrafficTopicServiceManager removeObject:ARNCreation];
}

//
//INOMMobileDeviceSubscribeDelegate methods
//
-(void)NewsMobileDeviceSubscribeCreation:(id)subrciption result:(BOOL)bOK
{
    if(subrciption == nil)
        return;
    
    if([subrciption isKindOfClass:[NOMNewsMobileDeviceSubscribeService class]])
    {
        if(bOK == YES)
        {
            if(m_Delegate)
                [m_Delegate MobileDeviceSubscribeDone];
        }
    }
    [m_TrafficTopicServiceManager removeObject:subrciption];
}


//
//INOMNewsTopicSearchDelegate methods
//
-(void)NewsTopicSearchCompletion:(id)search result:(BOOL)bOK
{
    if(search == nil)
        return;
    
     if([search isKindOfClass:[NOMNewsTopicSearchService class]])
     {
         NSString* szTopicName = [(NOMNewsTopicSearchService*)search GetTopicName];
         if([self IsTrafficTopicName:szTopicName] == YES)
         {
             if(bOK)
             {
                 m_TrafficTopicARN = [(NOMNewsTopicSearchService*)search GetTopicARN];
                 if(m_Delegate)
                     [m_Delegate TrafficTopicHookupDone];
             }
             else
             {
                 [self CreateTrafficTopic];
             }
         }
         else if([self IsTaxiTopicName:szTopicName] == YES)
         {
             if(bOK)
             {
                 m_TaxiTopicARN = [(NOMNewsTopicSearchService*)search GetTopicARN];
                 if(m_Delegate)
                     [m_Delegate TaxiTopicHookupDone];
             }
             else
             {
                 [self CreateTaxiTopic];
             }
         }
     }
    [m_TrafficTopicServiceManager removeObject:search];
}

//
//INOMNewsTopicCreateDelegate methods
//
-(void)NewsTopicCreateCompletion:(id)creation result:(BOOL)bOK
{
    if(creation == nil)
        return;
    
    if([creation isKindOfClass:[NOMNewsTopicCreateService class]])
    {
        if(bOK)
        {
            m_TrafficTopicARN = [(NOMNewsTopicCreateService*)creation GetTopicARN];
            if(m_Delegate)
                [m_Delegate TrafficTopicHookupDone];
        }
    }

    [m_TrafficTopicServiceManager removeObject:creation];
}

@end
