//
//  NOMNewsMessageQSubscribeService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-12-12.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMNewsMessageQSubscribeService.h"
#import "NOMSystemConstants.h"
#import "NOMAWSMergeModule.h"
#import "NOMAppInfo.h"

@interface  NOMNewsMessageQSubscribeService ()
{
    AmazonSNSClient*                m_SNSClient;
    AmazonSQSClient*                m_SQSClient;
    NSString*                       m_QueueURL;
    NSString*                       m_QueueARN;
    NSString*                       m_NewsTopicARN;
    id<INOMNewsMessageQSubscribeDelegate>         m_Delegate;
}

@end

@implementation NOMNewsMessageQSubscribeService

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withSQSClient:(AmazonSQSClient*)sqsClient withTopic:(NSString*)topicARN withQueueURL:(NSString*)queueURL
{
    self = [super init];
    
    if(self != nil)
    {
        m_SNSClient = snsClient;
        m_SQSClient =  sqsClient;
        m_NewsTopicARN = topicARN;
        m_QueueURL = queueURL;
        m_QueueARN = nil;
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMNewsMessageQSubscribeDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate MessageQSubscribeDone:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate MessageQSubscribeDone:self result:NO];
    }
}

-(void)CreateDefaultQueueARN
{
    if(m_QueueURL != nil && 0 < [m_QueueURL length])
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQSubscribeService  Q URL:%@", m_QueueURL);
#endif
        NSString* TempQString = m_QueueURL;
        
        NSString* arnPrefix = [NOMAppInfo GetAppAWSARNPrefix];
        NSString* szQString = [TempQString stringByReplacingOccurrencesOfString:@"https://sqs.us-east-1.amazonaws.com/" withString:arnPrefix];
        
        m_QueueARN = [szQString stringByReplacingOccurrencesOfString:@"/" withString:@":"];
        
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQSubscribeService Q ARN:%@", m_QueueARN);
#endif
        
        return;
    }
}

-(void)QueryQueueArn
{
    AWSSQSGetQueueAttributesRequest* gqar = [AWSSQSGetQueueAttributesRequest new];
    gqar.queueUrl = m_QueueURL;
    
    [[[m_SQSClient getQueueAttributes:gqar] continueWithBlock:^id(BFTask *task)
      {
          if (task.error)
          {
              //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQSubscribeService getQueueAttributes error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
              return nil;
          }
          if (task.result && [task.result isKindOfClass:[AWSSQSGetQueueAttributesResult class]] == YES)
          {
              AWSSQSGetQueueAttributesResult* response = task.result;
              m_QueueARN = [response.attributes valueForKey:@"QueueArn"];
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQSubscribeService getQueueAttributes succeeded for Q ARN:%@", m_QueueARN);
#endif
              if(m_QueueARN == nil || m_QueueARN.length <= 0)
              {
                  [self CreateDefaultQueueARN];
              }
          }
          return nil;
      }] waitUntilFinished];
}

-(void)SubscribeQueue
{
    if(m_SNSClient == nil || m_QueueARN == nil || [m_QueueARN length] <= 0 || m_NewsTopicARN == nil || [m_NewsTopicARN length] <= 0)
    {
        return;
    }
    AWSSNSSubscribeInput *request = [AWSSNSSubscribeInput new];
    request.endpoint = m_QueueARN;
    request.protocol = @"sqs";
    request.topicArn = m_NewsTopicARN;
    
    [[[m_SNSClient subscribe:request] continueWithBlock:^id(BFTask *task)
      {
          if (task.error)
          {
              //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQSubscribeService subscribe error : %@ for Q ARN:%@", task.error, m_QueueARN);
#endif
              m_QueueARN = nil;
              return nil;
          }
          else //if (task.result && [task.result isKindOfClass:[AWSSNSSubscribeResponse class]] == YES)
          {
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQSubscribeService subscribe succeeded for Q ARN:%@", m_QueueARN);
#endif
              return nil;
          }
          
          return nil;
      }] waitUntilFinished];
}

-(void)Start
{
    m_QueueARN = nil;
    if(m_SNSClient == nil || m_SQSClient == nil || m_QueueURL == nil || [m_QueueURL length] <= 0 || m_NewsTopicARN == nil || [m_NewsTopicARN length] <= 0)
    {
        [self ServiceFailed];
        return;
    }
    
    [self QueryQueueArn];
    [self SubscribeQueue];
    [self ServiceSucceeded];
}

@end
