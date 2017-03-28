//
//  NOMNewsTopicSearchService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-17.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMNewsTopicSearchService.h"

@interface NOMNewsTopicSearchService ()
{
    AmazonSNSClient*                        m_SNSClient;
    NSString*                               m_NewsTopicName;
    NSString*                               m_NewsTopicARN;
    id<INOMNewsTopicSearchDelegate>         m_Delegate;
}

@end


@implementation NOMNewsTopicSearchService

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withTopic:(NSString*)topicName
{
    self = [super init];
    
    if(self != nil)
    {
        m_SNSClient = snsClient;
        m_NewsTopicName = topicName;
        m_NewsTopicARN = nil;
        m_Delegate = nil;
    }
    
    return self;
}

-(NSString*)GetTopicARN
{
    return m_NewsTopicARN;
}

-(NSString*)GetTopicName
{
    return m_NewsTopicName;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NewsTopicSearchCompletion:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NewsTopicSearchCompletion:self result:NO];
    }
}

 
-(void)start
{
    if(m_SNSClient == nil || m_NewsTopicName == nil || [m_NewsTopicName length] <= 0)
    {
        [self ServiceFailed];
        return;
    }

    AWSSNSListTopicsInput *listTopicsRequest = [AWSSNSListTopicsInput new];
    [[[m_SNSClient listTopics:listTopicsRequest] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
        //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsTopicSearchService start task error : %@", task.error);
#endif
            [self ServiceFailed];
            return nil;
        }
        
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSNSListTopicsResponse class]])
            {
                AWSSNSListTopicsResponse *response = task.result;
                if(response != nil && response.topics && [response.topics isKindOfClass:[NSArray class]])
                {
                    NSString *topicNameToFind = [NSString stringWithFormat:@":%@", m_NewsTopicName];
                    for (AWSSNSTopic *topic in response.topics)
                    {
                        if ( [topic.topicArn hasSuffix:topicNameToFind])
                        {
                            m_NewsTopicARN = topic.topicArn;
#ifdef DEBUG
                            NSLog(@"NOMNewsTopicSearchService request succeed");
#endif
                            [self ServiceSucceeded];
                            return nil;
                        }
                    }
                }
            }
        }
        
#ifdef DEBUG
        NSLog(@"NOMNewsTopicSearchService request failed");
#endif
        [self ServiceFailed];
        return nil;
    }] waitUntilFinished];
}

-(void)RegisterDelegate:(id<INOMNewsTopicSearchDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)Start
{
    [self start];
}

@end
