//
//  NOMTopicPostService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-06-27.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMTopicPostService.h"

@interface NOMTopicPostService ()
{
    id<INOMTopicPostServiceDelegate>         m_Delegate;
    AmazonSNSClient*                        m_SNSClient;
    NSString*                               m_NewsTopicARN;
    NSString*                               m_Message;
}

@end

@implementation NOMTopicPostService

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withTopicARN:(NSString*)topicARN withMessage:(NSString*)message
{
    self = [super init];
    
    if(self != nil)
    {
        m_SNSClient = snsClient;
        m_NewsTopicARN = topicARN;
        m_Message = message;
        
        m_Delegate = nil;
    }
    
    return self;
}

-(void)RegisterDelegate:(id<INOMTopicPostServiceDelegate>)delegate
{
    m_Delegate = delegate;
}

-(NSString*)GetTopicARN
{
    return m_NewsTopicARN;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMPostServiceDone:self withResult:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate NOMPostServiceDone:self withResult:NO];
    }
}

-(void)start
{
    if(m_SNSClient == nil || m_NewsTopicARN == nil || [m_NewsTopicARN length] <= 0  || m_Message == nil || [m_Message length] <= 0)
    {
        [self ServiceFailed];
        return;
    }

    AWSSNSPublishInput *pr = [AWSSNSPublishInput new];
    pr.message = m_Message;
    pr.topicArn = m_NewsTopicARN;
   
    [[[m_SNSClient publish:pr] continueWithBlock:^id(BFTask *task)
    {
          if (task.error)
          {
              //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
              NSLog(@"NOMTopicPostService start task error : %@", task.error);
#endif
              [self ServiceFailed];
              return nil;
          }
          
#ifdef DEBUG
          NSLog(@"NOMTopicPostService request succeeded!");
#endif
          [self ServiceSucceeded];
          return nil;
    }] waitUntilFinished];
}

-(void)StartPost
{
    [self start];
}

@end
