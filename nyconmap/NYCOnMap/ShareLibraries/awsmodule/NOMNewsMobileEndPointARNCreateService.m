//
//  NOMNewsMobileEndPointARNCreateService.m
//  nyconmap
//
//  Created by Zhaohui Xing on 2014-04-22.
//  Copyright (c) 2014 Zhaohui Xing. All rights reserved.
//
#import "NOMNewsMobileEndPointARNCreateService.h"
#import "NOMAppInfo.h"

@interface NOMNewsMobileEndPointARNCreateService ()
{
    AmazonSNSClient*                                        m_SNSClient;
    NSString*                                               m_EndPointARN;
    NSString*                                               m_DeviceToken;
    id<INOMMobileEndPointARNCreationDelegate>        m_Delegate;
}

@end


@implementation NOMNewsMobileEndPointARNCreateService

-(id)initWithSNSClient:(AmazonSNSClient*)snsClient withDeviceToken:(NSString*)deviceToken
{
    self = [super init];
    
    if(self != nil)
    {
        m_SNSClient = snsClient;
        m_EndPointARN = nil;
        m_DeviceToken = deviceToken;
        m_Delegate = nil;
    }
    
    return self;
}

-(NSString*)GetEndPointARN
{
    return m_EndPointARN;
}

-(void)ServiceSucceeded
{
    if(m_Delegate != nil)
    {
        [m_Delegate MobileEndPointARNCreation:self result:YES];
    }
}

-(void)ServiceFailed
{
    if(m_Delegate != nil)
    {
        [m_Delegate MobileEndPointARNCreation:self result:NO];
    }
}

-(void)start
{
    NSString *platformApplicationArn = [NOMAppInfo GetPlatformApplicationARN];
    if(m_SNSClient == nil || m_DeviceToken == nil || [m_DeviceToken length] <= 0 || platformApplicationArn == nil || [platformApplicationArn length] <= 0)
    {
        [self ServiceFailed];
        return;
    }

    AWSSNSCreatePlatformEndpointInput *endpointReq = [AWSSNSCreatePlatformEndpointInput new];
    endpointReq.platformApplicationArn = [NOMAppInfo GetPlatformApplicationARN];
    endpointReq.token = m_DeviceToken;
    endpointReq.attributes  = @{@"Enabled":@"true"};
    
    [[[m_SNSClient createPlatformEndpoint:endpointReq] continueWithBlock:^id(BFTask *task)
    {
        if (task.error)
        {
#ifdef DEBUG
            NSLog(@"NOMNewsMobileEndPointARNCreateService start task error : %@", task.error);
#endif
            [self ServiceFailed];
            return nil;
        }
        
        if (task.result)
        {
            AWSSNSCreateEndpointResponse *endpointResponse = nil;
            if([task.result isKindOfClass:[AWSSNSCreateEndpointResponse class]] == YES)
            {
                endpointResponse = task.result;
                m_EndPointARN = endpointResponse.endpointArn;
#ifdef DEBUG
                NSLog(@"NOMNewsMobileEndPointARNCreateService: the EndPointARN:%@", m_EndPointARN);
#endif
                [self ServiceSucceeded];
            }
            else
            {
#ifdef DEBUG
                NSLog(@"NOMNewsMobileEndPointARNCreateService request failed");
#endif
                [self ServiceFailed];
            }
        }
        
        return nil;
    }] waitUntilFinished];
}

-(void)RegisterDelegate:(id<INOMMobileEndPointARNCreationDelegate>)delegate
{
    m_Delegate = delegate;
}

-(void)Start
{
    [self start];
}


@end
