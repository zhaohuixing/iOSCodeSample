//
//  NOMNewsMessageQFindService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-20.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsMessageQFindService.h"

@interface NOMNewsMessageQFindService ()
{
    AmazonSQSClient*                            m_SQSClient;
    NSString*                                   m_QueueName;
    NSString*                                   m_QueueURL;
    id<INOMNewsMessageQFindDelegate>         m_Delegate;
}


@end

@implementation NOMNewsMessageQFindService

-(id)initWithSQSClient:(AmazonSQSClient*)sqsClient withName:(NSString*)queueName
{
    self = [super init];
    
    if(self != nil)
    {
        m_SQSClient =  sqsClient;
        m_QueueName = queueName;
        m_QueueURL = nil;
        m_Delegate = nil;
    }
    
    return self;
}

-(NSString*)GetTrafficMessageQueueURL
{
    return m_QueueURL;
}

-(void)RegisterDelegate:(id<INOMNewsMessageQFindDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate MessageQFindDone:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate MessageQFindDone:self result:NO];
    }
}

-(void)start
{
    if(m_SQSClient == nil || m_QueueName == nil || [m_QueueName length] <= 0)
    {
        [self ServiceFailed];
        return;
    }
    
    NSString              *queueNameToFind = [NSString stringWithFormat:@"/%@", m_QueueName];
    AWSSQSListQueuesRequest  *request = [AWSSQSListQueuesRequest new];
    request.queueNamePrefix = m_QueueName;
    
    [[[m_SQSClient listQueues:request] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
            //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQFindService start task error : %@ for Q:%@", task.error, m_QueueName);
#endif
            [self ServiceFailed];
            return nil;
        }
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSQSListQueuesResult class]] == YES)
            {
                AWSSQSListQueuesResult *queuesResponse = task.result;
                
                for (NSString *qUrl in queuesResponse.queueUrls)
                {
                    if ( [qUrl hasSuffix:queueNameToFind])
                    {
                        m_QueueURL = qUrl;
#ifdef DEBUG
                        NSLog(@"NOMNewsMessageQFindService request succeed Q url:%@", m_QueueURL);
#endif
                        [self ServiceSucceeded];
                        return nil;
                    }
                }
            }
        }
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQFindService failed to find the Q:%@", m_QueueName);
#endif
        [self ServiceFailed];
        
        return nil;
    }] waitUntilFinished];
}

-(void)Start
{
    [self start];
}

@end
