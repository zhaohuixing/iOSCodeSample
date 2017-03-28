//
//  NOMNewsQueryTask.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-07-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsQueryTask.h"
#import "NOMNewsMetaDataRecord.h"
#import "NOMSystemConstants.h"
#import "NOMTimeHelper.h"
#import "NOMDataEncryptionHelper.h"

@interface NOMNewsQueryTask ()
{
    AmazonSQSClient*                            m_SQSClient;
    NSString*                                   m_QueueURL;
    id<INOMNewsQueryTaskDelegate>               m_Delegate;
    NSMutableArray*                             m_QueryMessages;

    int64_t                                     m_QueryNewsTimeInterval;
    int64_t                                     m_StartQueryTime;
    
    int32_t                                     m_nCurrentMessageCount;
}

-(void)StartQueryMessageTasks;

@end

@implementation NOMNewsQueryTask

-(id)initWithSQSClient:(AmazonSQSClient*)sqsClient withQueueURL:(NSString*)queueURL
{
    self = [super init];
    
    if(self != nil)
    {
        m_SQSClient = sqsClient;
        m_QueueURL = queueURL;
        m_Delegate = nil;
        m_QueryMessages = [[NSMutableArray alloc] init];
        m_QueryNewsTimeInterval = NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT;
        m_StartQueryTime = 0;
        m_nCurrentMessageCount = 0;
    }
    
    return self;
}

-(void)RemoveMessageFromMessageQueue:(AWSSQSMessage*)message
{
    //???????????????
    //!!!!!!!!!!!!!!!
    //
    //Todo: add remove message code here later
    //
    //!!!!!!!!!!!!!!!
    //???????????????
/*
    if(message != nil)
    {
    }
*/
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMNewsQueryTaskDone:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMNewsQueryTaskDone:self result:NO];
    }
}


-(void)SetQueryTimeThreshold:(int64_t)nTimeStep
{
    m_QueryNewsTimeInterval = nTimeStep;
}

-(void)ParseNewsJSONData:(NSDictionary*)jsonDictionary
{
    if(jsonDictionary != nil)
    {
        NOMNewsMetaDataRecord* pNewsData = [[NOMNewsMetaDataRecord alloc] init];
        if([pNewsData LoadFromJSONData:jsonDictionary] == YES)
        {
            int64_t nTimeStep = m_StartQueryTime - pNewsData.m_nNewsTime;
            if(nTimeStep < m_QueryNewsTimeInterval)
                [m_QueryMessages addObject:pNewsData];
        }
    }
}

-(void)HandleRawJSONData:(NSDictionary*)jsonDictionary
{
    if(jsonDictionary != nil)
    {
        NSString* szEncodeString = [jsonDictionary objectForKey:NOM_AWSSQS_MESSAGE_TAG];
        NSString* rawDataString = [NOMDataEncryptionHelper DecodingData:szEncodeString];
        NSError *jsonError = nil;
        NSData* rawData = [rawDataString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
        if(jsonObject != nil)
        {
            if ([jsonObject isKindOfClass:[NSArray class]])
            {
                NSLog(@"its an array!");
                NSArray *jsonArray = (NSArray *)jsonObject;
                NSLog(@"jsonArray - %@",jsonArray);
                for(NSDictionary *item in jsonArray)
                {
                    NSLog(@"Item: %@", item);
                    if(item != nil)
                    {
                        [self ParseNewsJSONData:item];
                    }
                }
            }
            else
            {
                NSLog(@"its probably a dictionary");
                NSDictionary *jsonDictionarySrc = (NSDictionary *)jsonObject;
                NSLog(@"jsonDictionary - %@", jsonDictionarySrc);
                if(jsonDictionarySrc != nil)
                {
                    [self ParseNewsJSONData:jsonDictionarySrc];
                }
            }
        }
    }
}

-(void)ParseNewsDataFromRawString:(NSString*)rawDataString
{
    if(rawDataString != nil && 0 < rawDataString.length)
    {
        NSError *jsonError = nil;
        NSData* rawData = [rawDataString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
        if(jsonObject != nil)
        {
            if ([jsonObject isKindOfClass:[NSArray class]])
            {
                NSLog(@"its an array!");
                NSArray *jsonArray = (NSArray *)jsonObject;
                NSLog(@"jsonArray - %@",jsonArray);
                for(NSDictionary *item in jsonArray)
                {
                    NSLog(@"Item: %@", item);
                    if(item != nil)
                    {
                        //[self ParseNewsJSONData:item];
                        [self HandleRawJSONData:item];
                    }
                }
            }
            else
            {
                NSLog(@"its probably a dictionary");
                NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
                NSLog(@"jsonDictionary - %@", jsonDictionary);
                if(jsonDictionary != nil)
                {
                    //[self ParseNewsJSONData:jsonDictionary];
                    [self HandleRawJSONData:jsonDictionary];
                }
            }
        }
    }
    
}


-(void)ParseSQSmessage:(AWSSQSMessage*)message
{
    if(message != nil)
    {
        [self ParseNewsDataFromRawString:message.body];
        [self RemoveMessageFromMessageQueue:message];
    }
}

-(void)HandleQueryMessageRawData:(NSArray*)messages endQuery:(BOOL)isEndQuery
{
    if(messages != nil && 0 < messages.count)
    {
        for(AWSSQSMessage* message in messages)
        {
            [self ParseSQSmessage:message];
        }
        if(isEndQuery == YES)
        {
            [self ServiceSucceeded];
        }
    }
    else
    {
        if(isEndQuery == YES)
        {
            [self ServiceFailed];
        }
    }
}

-(void)SyncQueryMessage
{
    AWSSQSReceiveMessageRequest* rmr = [AWSSQSReceiveMessageRequest new];
    rmr.queueUrl = m_QueueURL;
    rmr.visibilityTimeout   = [NSNumber numberWithInt:NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT];
    rmr.waitTimeSeconds = [NSNumber numberWithInt:30];
    BFTask *pMainTask = [m_SQSClient receiveMessage:rmr];
    
    BFTask *pThreadTask = [pMainTask continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsQueryTask SyncQueryMessage error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
            [self ServiceFailed];
            return nil;
        }
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSQSReceiveMessageResult class]] == YES)
            {
                AWSSQSReceiveMessageResult* response = task.result;
#ifdef DEBUG
                NSLog(@"NOMNewsQueryTask SyncQueryMessage succeeded for Q URL:%@ message count:%i\n", m_QueueURL, (int)response.messages.count);
#endif
                [self HandleQueryMessageRawData:response.messages endQuery:NO];
                if(response.messages != nil && 0 < response.messages.count)
                {
                    AWSSQSReceiveMessageRequest* rmrwork = [AWSSQSReceiveMessageRequest new];
                    rmrwork.queueUrl = m_QueueURL;
                    rmrwork.visibilityTimeout   = [NSNumber numberWithInt:NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT];
                    rmrwork.waitTimeSeconds = [NSNumber numberWithInt:30];
                    BFTask *pReturnTask = [m_SQSClient receiveMessage:rmrwork];
                    return pReturnTask;
                }
                else
                {
                    return nil;
                }
            }
        }
        return nil;
    }];
    
    while (pThreadTask != nil)
    {
        BFTask *pNextTask = [pThreadTask continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
        {
            if (task.error)
            {
#ifdef DEBUG
                NSLog(@"NOMNewsQueryTask SyncQueryMessage pThreadTask error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
                return nil;
            }
            if (task.result)
            {
                if([task.result isKindOfClass:[AWSSQSReceiveMessageResult class]] == YES)
                {
                    AWSSQSReceiveMessageResult* response = task.result;
#ifdef DEBUG
                    NSLog(@"NOMNewsQueryTask SyncQueryMessage receiveMessage pThreadTask succeeded for Q URL:%@ message count:%i\n", m_QueueURL, (int)response.messages.count);
#endif
                    [self HandleQueryMessageRawData:response.messages endQuery:NO];
                    if(response.messages != nil && 0 < response.messages.count)
                    {
                        AWSSQSReceiveMessageRequest* rmrwork = [AWSSQSReceiveMessageRequest new];
                        rmrwork.queueUrl = m_QueueURL;
                        rmrwork.visibilityTimeout   = [NSNumber numberWithInt:NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT];
                        rmrwork.waitTimeSeconds = [NSNumber numberWithInt:30];
                        BFTask *pReturnTask = [m_SQSClient receiveMessage:rmrwork];
                        return pReturnTask;
                    }
                    else
                    {
                        return nil;
                    }
                }
            }
            return nil;
        }];
        if(pNextTask == nil)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService pNextTask is empty\n");
#endif
            break;
        }
        
        pThreadTask = pNextTask;
    }
    
#ifdef DEBUG
    NSLog(@"NOMNewsMessageQCreateService SyncQueryMessage is finished successfully\n");
#endif
    [self ServiceSucceeded];
}

-(void)QueryMessages
{
/*
    AWSSQSReceiveMessageRequest* rmr = [AWSSQSReceiveMessageRequest new];
    rmr.queueUrl = m_QueueURL;
    //rmr.maxNumberOfMessages = [NSNumber numberWithInt:10];
    rmr.visibilityTimeout   = [NSNumber numberWithInt:1];
    rmr.waitTimeSeconds = [NSNumber numberWithInt:30];
    [[[m_SQSClient receiveMessage:rmr] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsQueryTask QueryMessages error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
            [self ServiceFailed];
            return nil;
        }
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSQSReceiveMessageResult class]] == YES)
            {
                AWSSQSReceiveMessageResult* response = task.result;
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService setQueueAttributes succeeded for Q URL:%@ message count:%i\n", m_QueueURL, (int)response.messages.count);
#endif
                [self HandleQueryMessageRawData:response.messages];
            }
        }
        return nil;
    }] waitUntilFinished];
*/
    
    //!!!!!!!!!!!!!
    //[self SyncQueryMessage];
    [self StartQueryMessageTasks];
}


-(void)StartQueryMessageTasks
{
    m_nCurrentMessageCount = 0;
    AWSSQSReceiveMessageRequest* rmr = [AWSSQSReceiveMessageRequest new];
    rmr.queueUrl = m_QueueURL;
    rmr.visibilityTimeout   = [NSNumber numberWithInt:NOM_SQS_VISIBLE_TIMEOUT_DEFAULT];
    rmr.waitTimeSeconds = [NSNumber numberWithInt:5];
    
    [[[m_SQSClient receiveMessage:rmr] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsQueryTask StartQueryMessageTasks error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
            [self ServiceFailed];
            return nil;
        }
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSQSReceiveMessageResult class]] == YES)
            {
                AWSSQSReceiveMessageResult* response = task.result;
#ifdef DEBUG
                NSLog(@"NOMNewsQueryTask StartQueryMessageTasks succeeded for Q URL:%@ message count:%i\n", m_QueueURL, (int)response.messages.count);
#endif
                [self HandleQueryMessageRawData:response.messages endQuery:NO];
                if(response.messages != nil && 0 < response.messages.count)
                {
                    m_nCurrentMessageCount = (int32_t)response.messages.count;
                }
            }
        }
        return nil;
    }] waitUntilFinished];
    
    if(m_nCurrentMessageCount <= 0)
    {
        [self ServiceSucceeded];
        return;
    }
    else
    {
        [self StartQueryMessageTasks];
    }
}

-(void)StartQuery
{
    m_nCurrentMessageCount = 0;
    m_StartQueryTime = [NOMTimeHelper CurrentTimeInInteger];
    if(m_SQSClient == nil || m_QueueURL == nil || m_QueueURL.length <= 0)
    {
        [self ServiceFailed];
        return;
    }
    [m_QueryMessages removeAllObjects];
    [self QueryMessages];
}

-(void)RegisterDelegate:(id<INOMNewsQueryTaskDelegate>)delegate
{
    m_Delegate = delegate;
}

-(NSArray*)GetQueryMessages
{
    return m_QueryMessages;
}

 
@end
