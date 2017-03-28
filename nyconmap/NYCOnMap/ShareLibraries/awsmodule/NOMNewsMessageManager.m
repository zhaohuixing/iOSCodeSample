//
//  NOMNewsMessageManager.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsMessageManager.h"
#import "NOMNewsQueryTask.h"
#import "NOMNewsMessageQFindService.h"
#import "NOMNewsMessageQCreateService.h"
#import "NOMNewsMessageQSubscribeService.h"
#import "NOMPreference.h"
#import "NOMNewsMetaDataRecord.h"


@interface NOMNewsMessageManager ()
{
    NSMutableArray*                 m_NewsMessageServiceManager;
    AmazonSQSClient*                m_MessageQueryService;
    AmazonSNSClient*                m_SNSService;
    
    NSString*                       m_NewsTopicARN;
    NSString*                       m_QueueName;

    NSString*                       m_QueueURL;
    NSString*                       m_QueueARN;
    
    id<NOMNewsMessageManagerDelegate>   m_Delegate;
    
    //Cached all queried traffic message from SQS for each search call
    //Fetch related type message from this queue to display on map
    NSMutableDictionary*              m_CachedNewsMessages;
    NSMutableArray*                   m_QueryMessageProcessList;
 
    int                               m_nSQSRetentionTimeInSecond;
}

-(void)CreateMessageQueue;

@end


@implementation NOMNewsMessageManager

-(void)addOperation:(NOMNewsMessageQCreateService*)operation
{
    [m_NewsMessageServiceManager addObject:operation];
}

-(id)initWithQueueName:(NSString*)queueName withSQSRentionTime:(int)nRentionTime
{
    self = [super init];
    
    if(self != nil)
    {
        m_NewsMessageServiceManager = [[NSMutableArray alloc] init];
        m_MessageQueryService = [AmazonClientManager CreateSQSClient];
        m_SNSService = nil;
        m_NewsTopicARN = nil;
        m_QueueName = queueName;
        m_QueueURL = nil;
        m_Delegate = nil;
        
        m_CachedNewsMessages = [[NSMutableDictionary alloc] init];
        m_QueryMessageProcessList = [[NSMutableArray alloc] init];
        m_nSQSRetentionTimeInSecond = nRentionTime;
    }
    
    return self;
}

-(NSDictionary*)GetCachedTrafficMessages
{
    return m_CachedNewsMessages;
}


-(AmazonSQSClient*)GetNewsMessageSQSClient
{
    return m_MessageQueryService;
}


-(NSString*)GetNewsMessageTopicARN
{
    return m_NewsTopicARN;
}

-(NSString*)GetNewsMessageQueueName
{
    return m_QueueName;
}

-(NSString*)GetNewsMessageQueueURL
{
    return m_QueueURL;
}

-(NSString*)GetNewsMessageQueueARN
{
    return m_QueueARN;
}


-(void)RegisterNewsTopic:(NSString*)topicARN withSNSClient:(AmazonSNSClient*)snsService
{
    m_NewsTopicARN = topicARN;
    m_SNSService = snsService;
}


-(void)RegisterDelegate:(id<NOMNewsMessageManagerDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)InitializeMessageQueueService
{
    NOMNewsMessageQFindService*  findQUrl = [[NOMNewsMessageQFindService alloc] initWithSQSClient:m_MessageQueryService withName:m_QueueName];
    [findQUrl RegisterDelegate:self];
    [m_NewsMessageServiceManager addObject:findQUrl];
    [findQUrl Start];
}

-(void)SubcribeNewsMessageQueueToNoficationService
{
    //!!!!!!!!!!!!
    NOMNewsMessageQSubscribeService* subcribeService = [[NOMNewsMessageQSubscribeService alloc] initWithSNSClient:m_SNSService withSQSClient:m_MessageQueryService withTopic:m_NewsTopicARN withQueueURL:m_QueueURL];
    [subcribeService RegisterDelegate:self];
    [m_NewsMessageServiceManager addObject:subcribeService];
    [subcribeService Start];
}

-(void)CreateMessageQueue
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(CreateMessageQueue) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NOMNewsMessageQCreateService* createURL = [[NOMNewsMessageQCreateService alloc] initWithSNSClient:m_SNSService withSQSClient:m_MessageQueryService withTopic:m_NewsTopicARN withName:m_QueueName withRetentionTime:m_nSQSRetentionTimeInSecond];
    [createURL RegisterDelegate:self];
    [self addOperation:createURL];
    [createURL Start];
}

-(void)HandleQueryNewsData:(NSArray*)messages
{
    if(messages && 0 < messages.count)
    {
       for(NOMNewsMetaDataRecord* pNewsData in messages)
       {
           if(pNewsData != nil && pNewsData.m_NewsID != nil && 0 < pNewsData.m_NewsID.length)
           {
               if([m_CachedNewsMessages objectForKey:pNewsData.m_NewsID] == nil)
               {
                   [m_CachedNewsMessages setObject:pNewsData forKey:pNewsData.m_NewsID];
               }
           }
       }
    }
    if(m_Delegate != nil)
    {
        [m_Delegate NewsMessageQueryCompleted:self];
    }
}


-(void)NOMNewsQueryTaskDone:(id)task result:(BOOL)bSuceeded
{
    if(bSuceeded && task && [task isKindOfClass:[NOMNewsQueryTask class]])
    {
        [self HandleQueryNewsData:[((NOMNewsQueryTask*)task) GetQueryMessages]];
    }
    else
    {
        if(m_Delegate != nil)
            [m_Delegate NewsMessageQueryFailed:self];
    }
    [m_QueryMessageProcessList removeObject:task];
}


-(void)RemoveNewsRecordByTimeStamp:(int64_t)nTimeBefore
{
    NSArray* keys = [m_CachedNewsMessages allKeys];
    if(keys != nil && 0 < keys.count)
    {
        for(int32_t i = (int32_t)keys.count-1; 0 <= i; --i)
        {
            NSString* key = [keys objectAtIndex:i];
            if(key != nil && 0 < key.length)
            {
                NOMNewsMetaDataRecord* pRecord = [m_CachedNewsMessages objectForKey:key];
                if(pRecord != nil)
                {
                    if(pRecord.m_nNewsTime <= nTimeBefore || pRecord.m_bRealTimeTrafficSearch == YES) //Remove all real time search datas
                    {
                        [m_CachedNewsMessages removeObjectForKey:key];
                    }
                }
            }
        }
    }
}

-(void)QueryNewsRecordsFromSQS
{
    NOMNewsQueryTask* pQueryTask = [[NOMNewsQueryTask alloc] initWithSQSClient:m_MessageQueryService withQueueURL:m_QueueURL];
    [pQueryTask RegisterDelegate:self];
    [m_QueryMessageProcessList addObject:pQueryTask];
    [pQueryTask StartQuery];
}

//
//INOMNewsMessageQCreationDelegate
//
-(void)MessageQCreationDone:(id)Qservice result:(BOOL)bOK
{
    if(Qservice == nil)
    {
        return;
    }
    
    if([Qservice isKindOfClass:[NOMNewsMessageQCreateService class]])
    {
        if(bOK == YES)
        {
            m_QueueURL = [((NOMNewsMessageQCreateService*)Qservice) GetTrafficMessageQueueURL];
            if(m_Delegate)
                [m_Delegate NewsMessageQueueInitialized:self result:NO];
        }
    }
    
    [m_NewsMessageServiceManager removeObject:Qservice];
}

//
//INOMNewsMessageQFindDelegate method
//
-(void)MessageQFindDone:(id)QFinder result:(BOOL)bSucceed
{
    if(QFinder == nil)
    {
        [self CreateMessageQueue];
        return;
    }
    if(bSucceed == NO)
    {
        [m_NewsMessageServiceManager removeObject:QFinder];
        [self CreateMessageQueue];
        return;
    }
    
    if([QFinder isKindOfClass:[NOMNewsMessageQFindService class]])
    {
        if(bSucceed == YES)
        {
            m_QueueURL = [((NOMNewsMessageQFindService*)QFinder) GetTrafficMessageQueueURL];
            if(m_Delegate)
                [m_Delegate NewsMessageQueueInitialized:self result:YES];
        }
        else
        {
            [self CreateMessageQueue];
        }
    }
    [m_NewsMessageServiceManager removeObject:QFinder];
}

//
//INOMNewsMessageQSubscribeDelegate
//
-(void)MessageQSubscribeDone:(id)Qservice result:(BOOL)bOK
{
    if(Qservice != nil)
        [m_NewsMessageServiceManager removeObject:Qservice];
    
    if(bOK)
    {
#ifdef DEBUG
        NSLog(@"Message Queue subscribes traffic topic succeeded!\n");
#endif
        if(m_Delegate)
            [m_Delegate QueryAllDataFromNewsSQS:self];
    }
#ifdef DEBUG
    else
    {
        NSLog(@"Message Queue subscribes traffic topic failed!\n");
    }
#endif
}


//
//Collect Data to Apple Watch open reqest
//
-(void)CollectNewsDataForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey
{
    NSArray* rawDataList = [m_CachedNewsMessages allValues];
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
        {
            if(pNewsData != nil && pNewsData.m_NewsID != nil && 0 < pNewsData.m_NewsID.length && pNewsData.m_bTwitterTweet == NO)
            {
                    NSDictionary* pData = [pNewsData CreateWatchAnnotationKeyValueBlock];
                    [dataArray addObject:pData];
            }
        }
        if(0 < dataArray.count)
        {
            [collectionSet setValue:dataArray forKey:szKey];
        }
    }
}

-(void)CollectNewsDataFromSocialMediaForAppleWatch:(NSMutableDictionary*)collectionSet storageKey:(NSString*)szKey
{
    NSArray* rawDataList = [m_CachedNewsMessages allValues];
    if(rawDataList != nil && 0 < rawDataList.count)
    {
        NSMutableArray* dataArray = [[NSMutableArray alloc] init];
        for(NOMNewsMetaDataRecord* pNewsData in rawDataList)
        {
            if(pNewsData != nil && pNewsData.m_NewsID != nil && 0 < pNewsData.m_NewsID.length && pNewsData.m_bTwitterTweet == YES)
            {
                NSDictionary* pData = [pNewsData CreateWatchAnnotationKeyValueBlock];
                [dataArray addObject:pData];
            }
        }
        if(0 < dataArray.count)
        {
            [collectionSet setValue:dataArray forKey:szKey];
        }
    }
}

@end
