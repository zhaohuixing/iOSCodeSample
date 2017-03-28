//
//  NOMNewsTopicCreateService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-18.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsTopicCreateService.h"

@interface NOMNewsTopicCreateService ()
{
    AmazonSNSClient*                            m_SNSClient;
    NSString*                                   m_NewsTopicName;
    NSString*                                   m_NewsTopicARN;
    id<INOMNewsTopicCreateDelegate>             m_Delegate;
}

@end

@implementation NOMNewsTopicCreateService

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
        [m_Delegate NewsTopicCreateCompletion:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NewsTopicCreateCompletion:self result:NO];
    }
}

-(void)SetTopicName
{
    AWSSNSSetTopicAttributesInput *st = [AWSSNSSetTopicAttributesInput new];
  
    st.attributeName = @"DisplayName";
    st.attributeValue = m_NewsTopicName;
    st.topicArn = m_NewsTopicARN;
    [[[m_SNSClient setTopicAttributes:st] continueWithBlock:^id(BFTask *task)
    {
        [self ServiceSucceeded];
        return nil;
    }] waitUntilFinished];
}

-(void)start
{
    m_NewsTopicARN = nil;
    if(m_SNSClient == nil || m_NewsTopicName == nil || [m_NewsTopicName length] <= 0)
    {
        [self ServiceFailed];
        return;
    }

    AWSSNSCreateTopicInput  *ctr = [AWSSNSCreateTopicInput new];
    ctr.name = m_NewsTopicName;
    
    [[[m_SNSClient createTopic:ctr] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
              //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsTopicCreateService start task error : %@", task.error);
#endif
            m_NewsTopicARN = nil;
            return nil;
        }
          
        if (task.result)
        {
            if([task.result isKindOfClass:[AWSSNSListTopicsResponse class]])
            {
                AWSSNSCreateTopicResponse *response = task.result;
                if(response != nil && response.topicArn && [response.topicArn isKindOfClass:[NSString class]])
                {
                    m_NewsTopicARN = response.topicArn;
                }
            }
        }
        return nil;
    }] continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        if(m_NewsTopicARN != nil)
        {
            [self SetTopicName];
        }
        else
        {
#ifdef DEBUG
            NSLog(@"NOMNewsTopicCreateService request failed");
#endif
            [self ServiceFailed];
        }
        return nil;
    }];
}

-(void)RegisterDelegate:(id<INOMNewsTopicCreateDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)Start
{
    [self start];
}

@end
