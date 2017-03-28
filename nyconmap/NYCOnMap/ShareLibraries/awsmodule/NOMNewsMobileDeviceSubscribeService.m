//
//  NOMNewsMobileDeviceSubscribeService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMNewsMobileDeviceSubscribeService.h"

@interface NOMNewsMobileDeviceSubscribeService ()
{
    AmazonSNSClient*                                    m_SNSClient;
    NSString*                                           m_EndPointARN;
    NSString*                                           m_NewsTopicARN;
    id<INOMMobileDeviceSubscribeDelegate>        m_Delegate;
}

@end

@implementation NOMNewsMobileDeviceSubscribeService

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withTopic:(NSString*)topicARN withEndPoint:(NSString*)endpointARN
{
    self = [super init];
    
    if(self != nil)
    {
        m_SNSClient = snsClient;
        m_EndPointARN = endpointARN;
        m_NewsTopicARN = topicARN;
        m_Delegate = nil;
    }
    
    return self;
}

-(NSString*)GetTopicARN
{
    return m_NewsTopicARN;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NewsMobileDeviceSubscribeCreation:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NewsMobileDeviceSubscribeCreation:self result:NO];
    }
}


-(void)_InternalStart
{
    if(m_SNSClient == nil || m_NewsTopicARN == nil || [m_NewsTopicARN length] <= 0 || m_EndPointARN == nil || [m_EndPointARN length] <= 0)
    {
        [self ServiceFailed];
        return;
    }

    AWSSNSSubscribeInput* sr = [AWSSNSSubscribeInput new];
    sr.endpoint = m_EndPointARN;
    sr.protocol = @"application";
    sr.topicArn = m_NewsTopicARN;
    
    [[[m_SNSClient subscribe:sr] continueWithBlock:^id(BFTask *task)
    {
          if (task.error)
          {
#ifdef DEBUG
              NSLog(@"NOMNewsMobileDeviceSubscribeService start task error : %@", task.error);
#endif
              [self ServiceFailed];
              return nil;
          }
          
          if (task.result)
          {
              if([task.result isKindOfClass:[AWSSNSSubscribeResponse class]] == YES)
              {
#ifdef DEBUG
                  NSLog(@"NOMNewsMobileDeviceSubscribeService request succeed");
#endif
                  [self ServiceSucceeded];
              }
              else
              {
#ifdef DEBUG
                  NSLog(@"NOMNewsMobileDeviceSubscribeService request failed");
#endif
                  [self ServiceFailed];
              }
          }
          
          return nil;
    }] waitUntilFinished];
}

-(void)RegisterDelegate:(id<INOMMobileDeviceSubscribeDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)Start
{
    [self _InternalStart];
}

@end
