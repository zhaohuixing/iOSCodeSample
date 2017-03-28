//
//  NOMNewsMessageQCreateService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-19.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//

#import "NOMNewsMessageQCreateService.h"
#import "NOMSystemConstants.h"
#import "NOMAWSMergeModule.h"
#import "NOMAppInfo.h"

@interface NOMNewsMessageQCreateService ()
{
    AmazonSNSClient*                            m_SNSClient;
    AmazonSQSClient*                            m_SQSClient;
    NSString*                                   m_QueueName;
    NSString*                                   m_QueueURL;
    NSString*                                   m_QueueARN;
    NSString*                                   m_NewsTopicARN;
    int                                         m_nRetentionTimeInSecond;
    id<INOMNewsMessageQCreationDelegate>        m_Delegate;
}

@end

@implementation NOMNewsMessageQCreateService

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withSQSClient:(AmazonSQSClient*)sqsClient withTopic:(NSString*)topicARN withName:(NSString*)queueName withRetentionTime:(int)nRetentionTimeInSecond
{
    self = [super init];
    
    if(self != nil)
    {
        m_SNSClient = snsClient;
        m_SQSClient =  sqsClient;
        m_QueueName = queueName;
        m_NewsTopicARN = topicARN;
        m_QueueURL = nil;
        m_QueueARN = nil;
        m_Delegate = nil;
        m_nRetentionTimeInSecond = nRetentionTimeInSecond;
    }
    
    return self;
}

-(NSString*)GetTrafficMessageQueueURL
{
    return m_QueueURL;
}

-(void)RegisterDelegate:(id<INOMNewsMessageQCreationDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate MessageQCreationDone:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate MessageQCreationDone:self result:NO];
    }
}

-(void)Finish
{
    if(m_QueueARN == nil || [m_QueueARN length] <= 0 || m_QueueURL == nil || [m_QueueURL length] <= 0)
        [self ServiceFailed];
    else
        [self ServiceSucceeded];
}

-(void)CreateDefaultQueueARN
{
    if(m_QueueURL != nil && 0 < [m_QueueURL length])
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService  Q URL:%@", m_QueueURL);
#endif
        NSString* TempQString = m_QueueURL;

        NSString* arnPrefix = [NOMAppInfo GetAppAWSARNPrefix];
        NSString* szQString = [TempQString stringByReplacingOccurrencesOfString:@"https://sqs.us-east-1.amazonaws.com/" withString:arnPrefix];
        
        m_QueueARN = [szQString stringByReplacingOccurrencesOfString:@"/" withString:@":"];
   
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService Q ARN:%@", m_QueueARN);
#endif
        
        return;
    }
}

-(void)QueryQueueArn
{
    if(m_SQSClient == nil || m_QueueURL == nil || [m_QueueURL length] <= 0)
    {
        return;
    }
    
    AWSSQSGetQueueAttributesRequest* gqar = [AWSSQSGetQueueAttributesRequest new];
    gqar.queueUrl = m_QueueURL;
    
    [[[m_SQSClient getQueueAttributes:gqar] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
            //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService getQueueAttributes error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
            return nil;
        }
        if (task.result && [task.result isKindOfClass:[AWSSQSGetQueueAttributesResult class]] == YES)
        {
            AWSSQSGetQueueAttributesResult* response = task.result;
            m_QueueARN = [response.attributes valueForKey:@"QueueArn"];
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService getQueueAttributes succeeded for Q ARN:%@", m_QueueARN);
#endif
            if(m_QueueARN == nil || m_QueueARN.length <= 0)
            {
                [self CreateDefaultQueueARN];
            }
        }
        return nil;
    }] waitUntilFinished];
}

-(NSString *)generateSqsPolicyForTopic //:(NSString *)queueArn
{
    NSString *string = nil;
    if(m_QueueARN == nil || m_QueueARN.length <= 0)
        return string;
        
    NSDictionary *policyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"2008-10-17", @"Version",
                               [NSString stringWithFormat:@"%@/policyId", m_QueueARN], @"Id",
                               [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [NSString stringWithFormat:@"%@/statementId", m_QueueARN], @"Sid",
                                                          @"Allow", @"Effect",
                                                          [NSDictionary dictionaryWithObject:@"*" forKey:@"AWS"], @"Principal",
                                                          @"SQS:SendMessage", @"Action",
                                                          m_QueueARN, @"Resource",
                                                          [NSDictionary dictionaryWithObject:
                                                           [NSDictionary dictionaryWithObject:m_NewsTopicARN forKey:@"aws:SourceArn"] forKey:@"StringEquals"], @"Condition",
                                                          nil],
                                nil], @"Statement",
                               nil];
    
    NSData* pJSON = nil;
    if(policyDic != nil && [NSJSONSerialization isValidJSONObject:policyDic] == YES)
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService generateSqsPolicyForTopic Proper JSON Object");
#endif
        NSError* error = nil;
        pJSON = [NSJSONSerialization dataWithJSONObject:policyDic options:NSJSONWritingPrettyPrinted error:&error];
        if(error != nil)
        {
            pJSON = nil;
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService generateSqsPolicyForTopic Failed to generate JSON object:%@", error);
#endif
        }
        string = [[NSString alloc] initWithData:pJSON encoding:NSUTF8StringEncoding];
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService generateSqsPolicyForTopic JSON string:%@", string);
#endif
    }
    
    return string;
}

-(void)ApplyQueueAttributes
{
    NSString* policyString = [self generateSqsPolicyForTopic];
    if(policyString == nil || policyString.length <= 0)
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService ApplyQueueAttributes empty policy string\n");
#endif
        return;
    }
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setValue:policyString forKey:@"Policy"];
    
    int nRetentionTimeInSecond = m_nRetentionTimeInSecond;
    NSNumber* objTime = [[NSNumber alloc] initWithInt:nRetentionTimeInSecond];
    [attributes setValue:objTime forKey:@"MessageRetentionPeriod"];
    
    AWSSQSSetQueueAttributesRequest* request = [AWSSQSSetQueueAttributesRequest new];
    request.queueUrl = m_QueueURL;
    request.attributes = attributes;
    
    [[[m_SQSClient setQueueAttributes:request] continueWithBlock:^id(BFTask *task)
      {
          if (task.error)
          {
              //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQCreateService setQueueAttributes error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
              return nil;
          }
          else
          {
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQCreateService setQueueAttributes succeeded for Q URL:%@", m_QueueURL);
#endif
              return nil;
          }
          return nil;
      }] waitUntilFinished];
    
}

-(void)SubscribeQueue
{
/*    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(SubscribeQueue) withObject:nil waitUntilDone:YES];
        return;
    }
*/
    
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
              NSLog(@"NOMNewsMessageQCreateService subscribe error : %@ for Q ARN:%@", task.error, m_QueueARN);
#endif
              m_QueueARN = nil;
              return nil;
          }
          else //if (task.result && [task.result isKindOfClass:[AWSSNSSubscribeResponse class]] == YES)
          {
#ifdef DEBUG
              NSLog(@"NOMNewsMessageQCreateService subscribe succeeded for Q ARN:%@", m_QueueARN);
#endif
              return nil;
          }
          
          return nil;
    }] waitUntilFinished];

}

-(void)start
{
    m_QueueURL = nil;
    m_QueueARN = nil;
    if(m_SNSClient == nil || m_SQSClient == nil || m_QueueName == nil || [m_QueueName length] <= 0 || m_NewsTopicARN == nil || [m_NewsTopicARN length] <= 0)
    {
        [self ServiceFailed];
        return;
    }
    
    AWSSQSCreateQueueRequest *cqr = [AWSSQSCreateQueueRequest new];
    cqr.queueName = m_QueueName;

    [[[m_SQSClient createQueue:cqr] continueWithBlock:^id(BFTask *task)
    {
        //AWSSQSCreateQueueResult
        if (task.error)
        {
                //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService createQueue error : %@ for Q:%@", task.error, m_QueueName);
#endif
            return nil;
        }
        if (task.result && [task.result isKindOfClass:[AWSSQSCreateQueueResult class]] == YES)
        {
            AWSSQSCreateQueueResult* response = task.result;
            m_QueueURL = response.queueUrl;
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService createQueue succeeded for Q URL:%@", m_QueueURL);
#endif
        }
        return nil;
    }] waitUntilFinished];
    
    [self QueryQueueArn];
    [self ApplyQueueAttributes];
    [self SubscribeQueue];
    
    [self Finish];

/*
    [[[[[m_SQSClient createQueue:cqr] continueWithBlock:^id(BFTask *task)
    {
        //AWSSQSCreateQueueResult
        if (task.error)
        {
            //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService createQueue error : %@ for Q:%@", task.error, m_QueueName);
#endif
            return nil;
        }
        if (task.result && [task.result isKindOfClass:[AWSSQSCreateQueueResult class]] == YES)
        {
            AWSSQSCreateQueueResult* response = task.result;
            m_QueueURL = response.queueUrl;
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService createQueue succeeded for Q URL:%@", m_QueueURL);
#endif
        }
        return nil;
    }] continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        [self QueryQueueArn];
        return nil;
    }] continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        [self ApplyQueueAttributes];
        return nil;
    }] continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
         [self SubscribeQueue];
         return nil;
    }] ;
*/
    
/*
    BFTask *pCreateQTask = [m_SQSClient createQueue:cqr];
    
    BFTask *pGetQAttributesTask = [pCreateQTask continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
                            //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService createQueue error : %@ for Q:%@", task.error, m_QueueName);
#endif
            return nil;
        }
        if (task.result && [task.result isKindOfClass:[AWSSQSCreateQueueResult class]] == YES)
        {
            AWSSQSCreateQueueResult* response = task.result;
            m_QueueURL = response.queueUrl;
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService createQueue succeeded for Q URL:%@", m_QueueURL);
#endif
            AWSSQSGetQueueAttributesRequest* gqar = [AWSSQSGetQueueAttributesRequest new];
            gqar.queueUrl = m_QueueURL;
            BFTask* pReturnTask = [m_SQSClient getQueueAttributes:gqar];
            return pReturnTask;
        }
        return nil;
    }];
    
    if(pGetQAttributesTask == nil)
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService pGetQAttributesTask is empty");
#endif
        [self Finish];
        return;
    }
    
    BFTask *pAppleQAttributesTask = [pGetQAttributesTask continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService getQueueAttributes error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
            return nil;
        }
        if (task.result && [task.result isKindOfClass:[AWSSQSGetQueueAttributesResult class]] == YES)
        {
            AWSSQSGetQueueAttributesResult* response = task.result;
            m_QueueARN = [response.attributes valueForKey:@"QueueArn"];
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService getQueueAttributes succeeded for Q ARN:%@", m_QueueARN);
#endif
            NSString* policyString = [self generateSqsPolicyForTopic];
            if(policyString == nil || policyString.length <= 0)
            {
#ifdef DEBUG
                NSLog(@"NOMNewsMessageQCreateService ApplyQueueAttributes empty policy string\n");
#endif
                return nil;
            }
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setValue:policyString forKey:@"Policy"];
            
            int nRetentionTimeInSecond = NOM_TRAFFICNEWS_SQS_RETENTION_TIME_DEFAULT;
            NSNumber* objTime = [[NSNumber alloc] initWithInt:nRetentionTimeInSecond];
            [attributes setValue:objTime forKey:@"MessageRetentionPeriod"];
            
            AWSSQSSetQueueAttributesRequest* request = [AWSSQSSetQueueAttributesRequest new];
            request.queueUrl = m_QueueURL;
            request.attributes = attributes;
            BFTask* pReturnTask = [m_SQSClient setQueueAttributes:request];
            return pReturnTask;
        }
        return nil;
    }];
 
    if(pAppleQAttributesTask == nil)
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService pAppleQAttributesTask is empty");
#endif
        [self Finish];
        return;
    }
    
    BFTask *pSubcribeQTask = [pAppleQAttributesTask continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService setQueueAttributes error : %@ for Q URL:%@", task.error, m_QueueURL);
#endif
            return nil;
        }
        else
        {
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService setQueueAttributes succeeded for Q URL:%@", m_QueueURL);
#endif
            AWSSNSSubscribeInput *request = [AWSSNSSubscribeInput new];
            request.endpoint = m_QueueARN;
            request.protocol = @"sqs";
            request.topicArn = m_TrafficTopicARN;
            
            BFTask* pReturnTask = [m_SNSClient subscribe:request];
            return pReturnTask;
        }
        return nil;
    }];
    
    if(pSubcribeQTask == nil)
    {
#ifdef DEBUG
        NSLog(@"NOMNewsMessageQCreateService pAppleQAttributesTask is empty");
#endif
        [self Finish];
        return;
    }

    [[pAppleQAttributesTask continueWithExecutor:[BFExecutor immediateExecutor] withBlock:^id(BFTask *task)
    {
        if (task.error)
        {
            //    XCTFail(@"Error: [%@]", task.error);
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService subscribe error : %@ for Q ARN:%@", task.error, m_QueueARN);
#endif
            m_QueueARN = nil;
        }
        else //if (task.result && [task.result isKindOfClass:[AWSSNSSubscribeResponse class]] == YES)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsMessageQCreateService subscribe succeeded for Q ARN:%@", m_QueueARN);
#endif
        }
        [self Finish];
        return nil;
    }] waitUntilFinished];
*/
}

-(void)Start
{
    [self start];
}
 
@end
