/*
 *  AmazonClientManager.mm
 *  newsonmap
 *
 *  Created by Zhaohui Xing on 2013-05-23.
 *  Copyright (c) 2013 Zhaohui Xing. All rights reserved.
*/
#import "AmazonClientManager.h"

#import "NOMAppInfo.h"

#define zhaohuixing_ACCESS_KEY_ID                   @"YOURAWSACCESSKEYID"
#define zhaohuixing_SECRET_KEY                      @"YOURAWSSCRETKEYID"

static BOOL                 g_AWSOK = YES;

static AmazonClientManager*   g_AWSClientManager = nil;

@interface AmazonClientManager ()
{
    AWSCognitoCredentialsProvider*      m_AWSCredentialProvider;
}

-(AmazonSimpleDBClient *)CreateSimpleDBClient;
-(AmazonS3Client *)CreateS3Client;
-(AmazonSQSClient *)CreateSQSClient;
-(AmazonSNSClient *)CreateSNSClient;
-(AmazonSESClient *)CreateSESClient;

@end


@implementation AmazonClientManager

+(BOOL)isAWSAvaliable
{
    return g_AWSOK;
}

+(void)setAWSAvaliable:(BOOL)bOK
{
    g_AWSOK = bOK;
}

+(AmazonClientManager*)GetSharedManager
{
    if(g_AWSClientManager == nil)
    {
        @synchronized (self)
        {
            g_AWSClientManager = [[AmazonClientManager alloc] init];
            [g_AWSClientManager InitializeAccess];
            assert(g_AWSClientManager != nil);
        }
    }
    return g_AWSClientManager;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        m_AWSCredentialProvider = nil;
    }
    
    return self;
}

-(void)InitializeAccess
{
    if(m_AWSCredentialProvider == nil)
    {
        NSLog(@"InitializeAccess");
        [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
        m_AWSCredentialProvider = [AWSCognitoCredentialsProvider credentialsWithRegionType:AWSRegionUSEast1
                                                                   accountId:[NOMAppInfo GetAWSAccountID]
                                                              identityPoolId:[NOMAppInfo GetAWSCognitoPoolID]
                                                               unauthRoleArn:[NOMAppInfo GetAWSCognitoRoleUnauth]
                                                                 authRoleArn:[NOMAppInfo GetAWSCognitoRoleAuth]];
    
        AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1 credentialsProvider:m_AWSCredentialProvider];
        [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    }
}

-(AmazonSimpleDBClient *)CreateSimpleDBClient
{
    AmazonSimpleDBClient* sdb = [[AmazonSimpleDBClient alloc] initWithDefaultConfiguration];
    return sdb;
}

+(AmazonSimpleDBClient *)CreateSimpleDBClient
{
    AmazonSimpleDBClient* sdb = [[AmazonClientManager GetSharedManager] CreateSimpleDBClient];
    return sdb;
}

-(AmazonS3Client *)CreateS3Client
{
    AmazonS3Client* pS3 = [[AmazonS3Client alloc] initWithDefaultConfiguration];
    return pS3;
}

+(AmazonS3Client *)CreateS3Client
{
    AmazonS3Client* pS3  = [[AmazonClientManager GetSharedManager] CreateS3Client];
    return pS3;
}

-(AmazonSQSClient *)CreateSQSClient
{
    AmazonSQSClient* sqs = [[AmazonSQSClient alloc] initWithDefaultConfiguration];
    return sqs;
}

+(AmazonSQSClient *)CreateSQSClient
{
    AmazonSQSClient* sqs = [[AmazonClientManager GetSharedManager] CreateSQSClient];
    return sqs;
}

-(AmazonSNSClient *)CreateSNSClient
{
    AmazonSNSClient* sns = [[AmazonSNSClient alloc] initWithDefaultConfiguration];
    return sns;
}

+(AmazonSNSClient *)CreateSNSClient
{
    AmazonSNSClient* sns = [[AmazonClientManager GetSharedManager] CreateSNSClient];
    return sns;
}

-(AmazonSESClient *)CreateSESClient
{
    AmazonSESClient* ses = [[AmazonSESClient alloc] initWithDefaultConfiguration];
    return ses;
}

+(AmazonSESClient *)CreateSESClient
{
    AmazonSESClient* ses = [[AmazonClientManager GetSharedManager] CreateSESClient];
    return ses;
}


@end
