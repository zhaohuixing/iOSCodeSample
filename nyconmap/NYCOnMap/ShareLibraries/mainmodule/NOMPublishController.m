//
//  NOMPublishController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-15.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMPublishController.h"
#import "NOMAppInfo.h"
#import "NOMTrafficSpotReportService.h"
#import "NOMSocialPostManager.h"
#import "NOMTrafficSpotDBHelper.h"
#import "NOMSystemConstants.h"
#import "NOMAppRegionHelper.h"

@interface NOMPublishController ()
{
    NSMutableArray*                         m_PublishMessageManager;
    
    NOMNewsTopicManager*                    m_NewsTopicServiceManager;
    
    NOMNewsMessagePublishManager*           m_TrafficMessagePublishManager;
    NOMNewsMessagePublishManager*           m_TaxiMessagePublishManager;
    
    
    NOMSocialPostManager*                   m_SocialPublishManager;
    
    id<NOMPublishControllerDelegate>        m_Delegate;
}

@end

@implementation NOMPublishController

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_NewsTopicServiceManager = [[NOMNewsTopicManager alloc] initWithTrafficTopicName:[NOMAppRegionHelper GetCurrentRegionTrafficTopicName] withTaxiTopicName:[NOMAppRegionHelper GetCurrentRegionTaxiTopicName]];
        
        
        [m_NewsTopicServiceManager RegisterDelegate:self];
        
        m_PublishMessageManager = [[NSMutableArray alloc] init];
    
        m_TrafficMessagePublishManager = [[NOMNewsMessagePublishManager alloc] init];
        [m_TrafficMessagePublishManager RegisterDelegate:self];

        m_TaxiMessagePublishManager = [[NOMNewsMessagePublishManager alloc] init];
        [m_TaxiMessagePublishManager RegisterDelegate:self];
        
        m_SocialPublishManager = [[NOMSocialPostManager alloc] init];
        
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<NOMPublishControllerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)HookupTrafficTopic
{
    [m_NewsTopicServiceManager HookupTrafficTopic];
}

-(void)HookupTaxiTopic
{
    [m_NewsTopicServiceManager HookupTaxiTopic];
}

-(void)TrafficTopicHookupDone
{
    if(m_Delegate != nil)
    {
        [m_Delegate TrafficTopicHookupDone];
    }
}

-(void)TaxiTopicHookupDone
{
    if(m_Delegate != nil)
    {
        [m_Delegate TaxiTopicHookupDone];
    }
}

-(void)MobileDeviceSubscribeDone
{
    if(m_Delegate != nil)
    {
        [m_Delegate MobileDeviceSubscribeDone];
    }
}

-(NSString*)GetTrafficTopicARN
{
    if(m_NewsTopicServiceManager != nil)
    {
        return [m_NewsTopicServiceManager GetTrafficTopicARN];
    }
    
    return nil;
}

-(NSString*)GetTrafficTopicName
{
    if(m_NewsTopicServiceManager != nil)
    {
        return [m_NewsTopicServiceManager GetTrafficTopicName];
    }
    
    return nil;
}

-(NSString*)GetTaxiTopicARN
{
    if(m_NewsTopicServiceManager != nil)
    {
        return [m_NewsTopicServiceManager GetTaxiTopicARN];
    }
    
    return nil;
}

-(NSString*)GetTaxiTopicName
{
    if(m_NewsTopicServiceManager != nil)
    {
        return [m_NewsTopicServiceManager GetTaxiTopicName];
    }
    
    return nil;
}

-(AmazonSNSClient*)GetSNSClient
{
    if(m_NewsTopicServiceManager != nil)
    {
        return [m_NewsTopicServiceManager GetSNSClient];
    }
    
    return nil;
}

-(void)InitializeMobilePushEndPointTrafficARN
{
    if(m_NewsTopicServiceManager != nil && [NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        [m_NewsTopicServiceManager InitializeMobilePushEndPointTrafficARN];
    }
}

-(void)InitializeMobilePushEndPointTaxiARN
{
    if(m_NewsTopicServiceManager != nil && [NOMAppInfo IsCityBaseAppRegionOnly] == YES)
    {
        [m_NewsTopicServiceManager InitializeMobilePushEndPointTaxiARN];
    }
}

-(void)HandleActiveRegionChanged
{
    if(m_NewsTopicServiceManager != nil)
    {
        [m_NewsTopicServiceManager HandleActiveRegionChanged];
    }
}

//
// INOMTrafficSpotReportDelegate mehods
//
-(void)NOMTrafficSpotReportTaskDone:(id)task result:(BOOL)bSuceeded
{
    if(task == nil)
    {
        //!!!!!!!!!
        return;
    }
    
    if(bSuceeded == YES && [task isKindOfClass:[NOMTrafficSpotReportService class]] == YES)
    {
        NOMTrafficSpotReportService* pSpotService = (NOMTrafficSpotReportService*)task;
        if(pSpotService != nil)
        {
            NOMTrafficSpotRecord* pSpot = [pSpotService GetSpotData];
            if(m_Delegate != nil)
            {
                [m_Delegate SpotPublished:pSpot];
            }
        }
    }
    
    [m_PublishMessageManager removeObject:task];
}

-(void)PublishSpot:(NOMTrafficSpotRecord*)pRecord shareOnTwitter:(BOOL)bShareOnTwitter
{
    if(pRecord == nil)
    {
        return;
    }

    NSString* szSpotDomain = [NOMTrafficSpotDBHelper GetDBDomain:pRecord.m_SpotLongitude withLatitude:pRecord.m_SpotLatitude withType:pRecord.m_Type];
    NOMTrafficSpotReportService* spotService = [[NOMTrafficSpotReportService alloc] initWith:szSpotDomain WithSpotData:pRecord];
    [spotService RegisterDelegate:self];
    [m_PublishMessageManager addObject:spotService];
    [spotService StartPost];
    
    //TODO: Sharing on twitter processing
/*    if(bShareOnTwitter == YES)
    {
        ACAccount* pAccount = [m_Delegate GetCurrentTwitterAccount];
        [m_SocialPublishManager StartSpotTwitterSharing:pRecord toAccount:pAccount];
    }
*/ 
}

-(void)NOMTrafficMessagePublishDone:(NOMNewsMetaDataRecord*)newsData result:(BOOL)bSuceeded
{
    if(newsData != nil && bSuceeded == YES)
    {
        if(m_Delegate != nil)
        {
            [m_Delegate NewsPublishedSuceed:newsData];
        }
    }
}

-(void)StartPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
         withSubject:(NSString*)szSubject
            withPost:(NSString*)szPost
         withKeyWord:(NSString*)szKeyWord
       withCopyRight:(NSString*)szCopyRight
             withKML:(NSString*)szKML
           withImage:(UIImage*)pImage
      shareOnTwitter:(BOOL)bShareOnTwitter
{
    if(pNewsMetaData != nil && pNewsMetaData.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        [m_TrafficMessagePublishManager SetTopicARN:[self GetTrafficTopicARN]];
        [m_TrafficMessagePublishManager StartPostNews:pNewsMetaData
                                          withSubject:szSubject
                                             withPost:szPost
                                          withKeyWord:szKeyWord
                                        withCopyRight:szCopyRight
                                              withKML:szKML
                                            withImage:pImage];
 
        //TODO: Sharing on twitter processing
        if(bShareOnTwitter == YES)
        {
            ACAccount* pAccount = [m_Delegate GetCurrentTwitterAccount];
            [m_SocialPublishManager StartTwitterSharing:pNewsMetaData withPost:szPost withImage:pImage toAccount:pAccount];
        }
    }
    else if(pNewsMetaData != nil && pNewsMetaData.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
    {
        [m_TaxiMessagePublishManager SetTopicARN:[self GetTaxiTopicARN]];
        [m_TaxiMessagePublishManager StartPostNews:pNewsMetaData
                                          withSubject:szSubject
                                             withPost:szPost
                                          withKeyWord:szKeyWord
                                        withCopyRight:szCopyRight
                                              withKML:szKML
                                            withImage:pImage];
        
        //TODO: Sharing on twitter processing
        /*
        if(bShareOnTwitter == YES)
        {
            ACAccount* pAccount = [m_Delegate GetCurrentTwitterAccount];
            [m_SocialPublishManager StartTwitterSharing:pNewsMetaData withPost:szPost withImage:pImage toAccount:pAccount];
        }*/
    }
}

-(void)DirectPostNews:(NOMNewsMetaDataRecord*)pNewsMetaData
{
    if(pNewsMetaData != nil && (pNewsMetaData.m_NewsMainCategory == NOM_NEWSCATEGORY_LOCALTRAFFIC || NOM_NEWSCATEGORY_NONENEWS_BASE_ID <= pNewsMetaData.m_NewsMainCategory))
    {
        [m_TrafficMessagePublishManager SetTopicARN:[self GetTrafficTopicARN]];
        [m_TrafficMessagePublishManager DirectPostNews:pNewsMetaData];
    }
    else if(pNewsMetaData != nil && pNewsMetaData.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
    {
        [m_TaxiMessagePublishManager SetTopicARN:[self GetTaxiTopicARN]];
        [m_TaxiMessagePublishManager DirectPostNews:pNewsMetaData];
    }
}

-(void)StartPostTaxiInformation:(NOMNewsMetaDataRecord*)pNewsMetaData
{
    if(pNewsMetaData != nil && pNewsMetaData.m_NewsMainCategory == NOM_NEWSCATEGORY_TAXI)
    {
        [m_TaxiMessagePublishManager SetTopicARN:[self GetTaxiTopicARN]];
        [m_TaxiMessagePublishManager DirectPostNews:pNewsMetaData];
    }
}

@end
