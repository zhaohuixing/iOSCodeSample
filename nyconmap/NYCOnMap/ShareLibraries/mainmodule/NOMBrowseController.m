//
//  NOMBrowseController.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMBrowseController.h"
#import "NOMTrafficSpotSearchManager.h"
#import "NOMTrafficSpotQueryService.h"
#import "NOMSocialSearchManager.h"
#import "NOMAppRegionHelper.h"
#import "NOMSystemConstants.h"
#import "NOMNewsMetaDataRecord.h"
#import "NOMTimeHelper.h"
#import "NOMPreference.h"
#import "NOMAppWatchConstants.h"
#ifdef DEBUG
#import "NOMDocumentController.h"
#endif



@interface NOMBrowseController ()
{
    NOMNewsMessageManager*                      m_TrafficMessageQueryManager;
    NOMNewsMessageManager*                      m_TaxiMessageQueryManager;
    
    NOMTrafficSpotSearchManager*                m_TrafficSpotQueryManager;
    NOMSocialSearchManager*                     m_SocialSearchManager;
    id<NOMBrowseControllerDelegate>             m_Delegate;
    NSMutableArray*                             m_SpotQueryTaskQueue;

#ifdef USING_TOMTOMSDK
    TTServiceManager*                           m_RealTimeTrafficSearchServiceManager;
#endif

}

#ifdef USING_TOMTOMSDK
-(void)SearchRealTimeTrafficInformation;
#endif

@end

@implementation NOMBrowseController

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_Delegate = nil;
        
        m_SpotQueryTaskQueue = [[NSMutableArray alloc] init];
        
        m_TrafficMessageQueryManager = [[NOMNewsMessageManager alloc] initWithQueueName:[[NOMPreference GetSharedPreference] GetTrafficMessageQueueName] withSQSRentionTime:NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT];
        [m_TrafficMessageQueryManager RegisterDelegate:self];

        m_TaxiMessageQueryManager = [[NOMNewsMessageManager alloc] initWithQueueName:[[NOMPreference GetSharedPreference] GetTaxiMessageQueueName] withSQSRentionTime:NOM_TAXINEWS_SQS_RETENTION_TIME_DEFAULT];
        [m_TaxiMessageQueryManager RegisterDelegate:self];

        m_TrafficSpotQueryManager = [[NOMTrafficSpotSearchManager alloc] initWithOperationManager:m_SpotQueryTaskQueue];
        [m_TrafficSpotQueryManager RegisterDelegate:self];
        m_SocialSearchManager = [[NOMSocialSearchManager alloc] init];
        [m_SocialSearchManager RegisterDelegate:self];
        
#ifdef USING_TOMTOMSDK
        m_RealTimeTrafficSearchServiceManager = [[TTServiceManager alloc] init];
        [m_RealTimeTrafficSearchServiceManager RegisterDelegate:self];
#endif
    }
    
    return self;
}


-(void)RegisterTrafficTopic:(NSString*)topicARN withSNSClient:(AmazonSNSClient*)snsService
{
    if(m_TrafficMessageQueryManager != nil)
    {
        [m_TrafficMessageQueryManager RegisterNewsTopic:topicARN withSNSClient:snsService];
    }
}


-(void)RegisterDelegate:(id<NOMBrowseControllerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)InitializeTrafficMessageQueueService
{
    if(m_TrafficMessageQueryManager != nil)
    {
        [m_TrafficMessageQueryManager InitializeMessageQueueService];
    }
}

-(void)RegisterTaxiTopic:(NSString*)topicARN withSNSClient:(AmazonSNSClient*)snsService
{
    if(m_TaxiMessageQueryManager != nil)
    {
        [m_TaxiMessageQueryManager RegisterNewsTopic:topicARN withSNSClient:snsService];
    }
}

-(void)InitializeTaxiMessageQueueService
{
    if(m_TaxiMessageQueryManager != nil)
    {
        [m_TaxiMessageQueryManager InitializeMessageQueueService];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOMNewsMessageManagerDelegate methods begin
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)NewsMessageQueueInitialized:(id)newsMan result:(BOOL)bNeedSubcribe
{
    if(m_Delegate != nil && newsMan != nil)
    {
        if(newsMan == m_TrafficMessageQueryManager)
            [m_Delegate TrafficMessageQueueInitialized:bNeedSubcribe];
        else if(newsMan == m_TaxiMessageQueryManager)
            [m_Delegate TaxiMessageQueueInitialized:bNeedSubcribe];
    }
}

-(void)NewsMessageQueryCompleted:(id)msgMan
{
    //??????
    //??????
    //??????
    //??????
#ifdef DEBUG
    [(NOMDocumentController*)m_Delegate SendDebugMessageToAppleWatch:@"NewsMessageQueryCompleted"];
#endif
    if(msgMan == nil)
        return;
    
    if(msgMan == m_TrafficMessageQueryManager)
    {
        NSDictionary* trafficNewsDataList = [m_TrafficMessageQueryManager GetCachedTrafficMessages];
        if(trafficNewsDataList != nil && 0 < trafficNewsDataList.count)
        {
            NSArray* rawDataList = [trafficNewsDataList allValues];
            if(rawDataList != nil && 0 < rawDataList.count)
            {
                for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
                {
                    if(pNewsData != nil)
                    {
                        if(m_Delegate)
                            [m_Delegate PinNewsDataOnMap:pNewsData];
                    }
                }
                if(m_Delegate)
                    [m_Delegate SendTrafficMessagesToWatch:rawDataList];
            }
        }
    }
    else if(msgMan == m_TaxiMessageQueryManager)
    {
        NSDictionary* trafficNewsDataList = [m_TaxiMessageQueryManager GetCachedTrafficMessages];
        if(trafficNewsDataList != nil && 0 < trafficNewsDataList.count)
        {
            NSArray* rawDataList = [trafficNewsDataList allValues];
            if(rawDataList != nil && 0 < rawDataList.count)
            {
                for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
                {
                    if(pNewsData != nil)
                    {
                        if(m_Delegate)
                            [m_Delegate PinNewsDataOnMap:pNewsData];
                    }
                }
                if(m_Delegate)
                    [m_Delegate SendTaxiMessagesToWatch:rawDataList];
            }
        }
    }
}

-(void)NewsMessageQueryFailed:(id)msgMan
{
#ifdef DEBUG
    [(NOMDocumentController*)m_Delegate SendDebugMessageToAppleWatch:@"NewsMessageQueryFailed:(id)msgMan"];
#endif

    if(msgMan == nil)
        return;
    
    //if(msgMan == m_TrafficMessageQueryManager)
    //{
        //if(m_Delegate)
        //    [m_Delegate tra];
    //}
}

-(void)QueryAllDataFromNewsSQS:(id)msgMan
{
    if(msgMan == nil)
        return;
    
    if(msgMan == m_TrafficMessageQueryManager)
    {
        [self QueryAllDataFromTrafficSQS];
    }
    else if(msgMan == m_TaxiMessageQueryManager)
    {
        [self QueryAllDataFromTaxiSQS];
    }
}

-(void)QueryAllDataFromTrafficSQS
{
    int64_t nCurrentTime = [NOMTimeHelper CurrentTimeInInteger];
    int64_t nTimeBefore = nCurrentTime - NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT;
    
    if(m_TrafficMessageQueryManager != nil)
    {
        [m_TrafficMessageQueryManager RemoveNewsRecordByTimeStamp:nTimeBefore];
        
        
        [m_TrafficMessageQueryManager QueryNewsRecordsFromSQS];
    }
    if(m_SocialSearchManager != nil)
    {
        ACAccount* pAccount = [m_Delegate GetCurrentTwitterAccount];
        if(pAccount != nil)
            [m_SocialSearchManager SearchTwitter:NOM_NEWSCATEGORY_LOCALTRAFFIC withAccount:pAccount fromTime:nTimeBefore toTime:nCurrentTime];
    }
    
#ifdef USING_TOMTOMSDK
    [self SearchRealTimeTrafficInformation];
#endif
    
}

-(void)QueryAllDataFromTaxiSQS
{
    int64_t nCurrentTime = [NOMTimeHelper CurrentTimeInInteger];
    int64_t nTimeBefore = nCurrentTime - NOM_TAXINEWS_SQS_RETENTION_TIME_DEFAULT;
    
    if(m_TaxiMessageQueryManager != nil)
    {
        [m_TaxiMessageQueryManager RemoveNewsRecordByTimeStamp:nTimeBefore];
        [m_TaxiMessageQueryManager QueryNewsRecordsFromSQS];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//NOMNewsMessageManagerDelegate methods end
////////////////////////////////////////////////////////////////////////////////////////////////////////



-(void)SubcribeTrafficMessageQueueToNoficationService
{
    if(m_TrafficMessageQueryManager != nil)
    {
        [m_TrafficMessageQueryManager SubcribeNewsMessageQueueToNoficationService];
    }
}

-(void)SubcribeTaxiMessageQueueToNoficationService
{
    if(m_TaxiMessageQueryManager != nil)
    {
        [m_TaxiMessageQueryManager SubcribeNewsMessageQueueToNoficationService];
    }
}

-(void)HandleActiveRegionChanged
{
    
}

-(void)UpdateQueryRegion:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    
}


-(void)ProcessTrafficSpotService:(NOMTrafficSpotQueryService*)service
{
    if(m_Delegate != nil && service != nil)
    {
        NSArray* spotList = [service GetItemList];
        if(spotList != nil && 0 < spotList.count)
        {
            [m_Delegate HandleSearchTrafficSpotList:spotList withSpotType:[service GetSpotType]];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// INOMTrafficSpotQueryDelegate methods begin
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)NOMTrafficSpotQueryTaskDone:(id)task result:(BOOL)bSuceeded
{
    if(task == nil)
    {
        //!!!!!!!!
        return;
    }
    
    if(bSuceeded == YES && [task isKindOfClass:[NOMTrafficSpotQueryService class]] == YES)
    {
        [self ProcessTrafficSpotService:((NOMTrafficSpotQueryService*)task)];
    }
    
    [m_SpotQueryTaskQueue removeObject:task];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// INOMTrafficSpotQueryDelegate methods end
////////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)RegisterQuerySpotTrackingEvent:(int16_t)nType
{
/*    NSString* szPostTitle = [StringFactory GetString_SpotTitle:nType];
    AIServiceManager* pTrackingMgr =[AIServiceManager getAmazonAnalyticsService];
    
    if(pTrackingMgr != nil)
    {
        [pTrackingMgr RegisterQuerySpotTrackingEvent:szPostTitle];
    }*/
}

-(void)SearchTrafficSpots:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd
{
    if(m_TrafficSpotQueryManager != nil)
    {
        [self RegisterQuerySpotTrackingEvent:NOM_TRAFFICSPOT_PHOTORADAR];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_PHOTORADAR];
        [self RegisterQuerySpotTrackingEvent:NOM_TRAFFICSPOT_SCHOOLZONE];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_SCHOOLZONE];
        [self RegisterQuerySpotTrackingEvent:NOM_TRAFFICSPOT_PLAYGROUND];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_PLAYGROUND];
        [self RegisterQuerySpotTrackingEvent:NOM_TRAFFICSPOT_GASSTATION];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_GASSTATION];
        [self RegisterQuerySpotTrackingEvent:NOM_TRAFFICSPOT_PARKINGGROUND];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_PARKINGGROUND];
        [self UpdateQueryRegion:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
    }
}

-(void)SearchTrafficSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType
{
    if(m_TrafficSpotQueryManager != nil)
    {
        [self RegisterQuerySpotTrackingEvent:nType];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:nType];
        [self UpdateQueryRegion:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
    }
}

-(void)SearchTrafficSpotRecords:(double)latStart toLatitude:(double)latEnd fromLongitude:(double)lonStart toLongitude:(double)lonEnd withType:(int16_t)nType withSubType:(int16_t)nSubType
{
    if(m_TrafficSpotQueryManager != nil)
    {
        [self RegisterQuerySpotTrackingEvent:nType];
        [m_TrafficSpotQueryManager SearchSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:nType withSubType:nSubType];
        [self UpdateQueryRegion:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
    }
}

-(void)BrowseSpots:(int16_t)nType spotDS:(int16_t)nSpotDS
{
    double latStart, latEnd, lonStart, lonEnd;
    [NOMAppRegionHelper GetCurrentRegion:&latStart toLatitude:&latEnd fromLongitude:&lonStart toLongitude:&lonEnd];
    if(nType == -1)
    {
        [self SearchTrafficSpots:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd];
    }
    else if(nType == NOM_TRAFFICSPOT_PHOTORADAR)
    {
        if(nSpotDS == -1)
        {
            [self SearchTrafficSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:nType];
        }
        else
        {
            [self SearchTrafficSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:nType withSubType:nSpotDS];
        }
    }
    else if(nType == NOM_TRAFFICSPOT_ALL_SPEEDLIMIT)
    {
        [self SearchTrafficSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_PHOTORADAR];
        [self SearchTrafficSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_SCHOOLZONE];
        [self SearchTrafficSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:NOM_TRAFFICSPOT_PLAYGROUND];
    }
    else
    {
        [self SearchTrafficSpotRecords:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withType:nType];
    }
}

-(void)BrowseTrafficNewsFromSQS:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate
{
    if(nSubCate == NOM_NEWSCATEGORY_LOCALTRAFFIC_SUBCATEGORY_ALL)
    {
        [self QueryAllDataFromTrafficSQS];
    }
}

-(void)BrowseNewsFromSQS:(int16_t)nMainCate subCate:(int16_t)nSubCate thirdCate:(int16_t)nThirdCate
{
    if(nMainCate == NOM_NEWSCATEGORY_LOCALTRAFFIC)
    {
        [self BrowseTrafficNewsFromSQS:nSubCate thirdCate:nThirdCate];
    }
}

-(void)BrowseAllTrafficNews
{
/*    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self QueryAllDataFromTrafficSQS];
    });
*/
#ifdef DEBUG
//    [(NOMDocumentController*)m_Delegate SendDebugMessageToAppleWatch:@"BrowseController BrowseAllTrafficNews"];
#endif
    [self QueryAllDataFromTrafficSQS];
}

-(void)BrowseAllTaxiNews
{
/*    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^(void)
    {
        [self QueryAllDataFromTaxiSQS];
    });*/
    [self QueryAllDataFromTaxiSQS];
}

-(void)HandleSearchResult:(id)record
{
    if(record != nil && [record isKindOfClass:[NOMNewsMetaDataRecord class]] == YES)
    {
        if(m_Delegate)
        {
            [m_Delegate PinNewsDataOnMap:(NOMNewsMetaDataRecord*)record];
            //[record StartTweetLocationDecode];
        }
    }
}

-(void)HandleSoicalSearchToWatch:(NSArray*)dataArray
{
    if(m_Delegate)
    {
        [m_Delegate HandleSoicalSearchToWatch:dataArray];
    }
}

#ifdef USING_TOMTOMSDK
-(void)SearchRealTimeTrafficInformation
{
    double latStart, latEnd, lonStart, lonEnd;
    [NOMAppRegionHelper GetCurrentRegion:&latStart toLatitude:&latEnd fromLongitude:&lonStart toLongitude:&lonEnd];
    [m_RealTimeTrafficSearchServiceManager SearchTraffic:latStart toLatitude:latEnd fromLongitude:lonStart toLongitude:lonEnd withZoom:1.0];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//TTServiceManagerDelegate metods begin
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)ProcessTrafficSearchData:(NOMRTSSourceService*)pSearchRecord
{
    if(pSearchRecord != nil)
    {
        NOMNewsMetaDataRecord *pRecord = [[NOMNewsMetaDataRecord alloc] init];
        [pRecord SetTrafficRouteSource:pSearchRecord];
        if(m_Delegate)
            [m_Delegate PinNewsDataOnMap:pRecord];
    }
}

-(void)TrafficSearchDone:(NSArray*)pRouteList withResult:(BOOL)bSucceed
{
    if(bSucceed == YES && pRouteList != nil && 0 < (int)pRouteList.count)
    {
        for(NOMRTSSourceService* pSearchRecord in pRouteList)
        {
            if(pSearchRecord != nil)
            {
                [self ProcessTrafficSearchData:pSearchRecord];
            }
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
//TTServiceManagerDelegate metods end
////////////////////////////////////////////////////////////////////////////////////////////////////////
#endif
@end
